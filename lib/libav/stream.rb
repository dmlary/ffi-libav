require 'ffi/libav'

# Generic Stream class.  Most of the logic resides in Libav::Stream::Video.
module Libav::Stream
  extend Forwardable
  include FFI::Libav

  attr_reader :reader, :av_stream, :av_codec_ctx
  def_delegator :@av_stream, :[], :[]

  def initialize(p={})
    @reader = p[:reader] or raise ArgumentError, "no :reader"
    @av_stream = p[:av_stream] or raise ArgumentError, "no :av_stream"
    @av_codec_ctx = @av_stream[:codec]

    # open the codec
    codec = avcodec_find_decoder(@av_codec_ctx[:codec_id]) or
      raise RuntimeError, "No decoder found for #{@av_codec_ctx[:codec_id]}"
    avcodec_open2(@av_codec_ctx, codec, nil) == 0 or
      raise RuntimeError, "avcodec_open() failed"
  end

  def discard=(value)
    @av_stream[:discard] = value
  end

  def discard
    @av_stream[:discard]
  end

  def type
    @av_codec_ctx[:codec_type]
  end

  def index
    @av_stream[:index]
  end

  def decode_frame(packet)
    return false
    raise NotImplementedError, "decode_frame() not defined for #{self.class}"
  end

  # Loop through each frame of this stream
  def each_frame(&block)
    @reader.each_frame { |frame| yield frame if frame.stream == self }
  end

  # Get the next frame in the stream
  def next_frame
    frame = nil
    each_frame { |f| frame = f; break }
    frame
  end

  # Skip some +n+ frames in the stream
  def skip_frames(n)
    raise RuntimeError, "Cannot skip frames when discarding all frames" if
      discard == :all
    each_frame { |f| (n -= 1) != 0 }
  end

  # Seek to a specific location within the stream; the location can be either
  # a PTS value or an absolute byte position.
  #
  # Arguments:
  #   [:pts]  PTS location
  #   [:pos]  Byte location
  #   [:backward] Seek backward
  #   [:any]  Seek to non-key frames
  #
  def seek(p={})
    p = { :pts => p } unless p.is_a? Hash

    raise ArgumentError, "No location provided" if \
      (p.keys & [:pos, :pts]).empty?

    raise ArgumentError, ":pts and :pos are mutually exclusive" \
      if p[:pts] and p[:pos]

    pos = p[:pts] || p[:pos]
    flags = 0
    flags |= AVSEEK_FLAG_BYTE if p[:pos]
    flags |= AVSEEK_FLAG_BACKWARD if p[:backward]
    flags |= AVSEEK_FLAG_ANY if p[:any]

    # We're about to perform a seek, so let's prevent future updates to the FFS
    # data.
    @update_ffs = false

    rc = av_seek_frame(@reader.av_format_ctx, @av_stream[:index], pos, flags)
    raise RuntimeError, "av_seek_frame() failed, %d" % rc if rc < 0
    true
  end
end

class Libav::Stream::Video
  include Libav::Stream

  attr_reader :width, :height, :pixel_format, :reader, :ffs

  def initialize(p={})
    super(p)

    # Handle frame width and height and setup any scaling necessary
    @width  = p[:widht]  || @av_codec_ctx[:width]
    @height = p[:height] || @av_codec_ctx[:height]
    @pixel_format = p[:pixel_format] || @av_codec_ctx[:pix_fmt]
    init_scaling

    # Our frame structure for decoding the frame
    @raw_frame = Libav::Frame::Video.new :stream => self, :alloc => false,
                                          :width => @av_codec_ctx[:width],
                                          :height => @av_codec_ctx[:height],
                                          :pixel_format =>
                                            @av_codec_ctx[:pix_fmt]

    # Pointer used to denote that decode frame was successful
    @frame_finished = FFI::MemoryPointer.new :int

    # Elaborate schemes to capture an accurate pts value.  When the buffer for
    # the frame is allocated, we pull the dts from the last packet processed
    # (set in decode_frame()), and set it in the opaque field of the frame.
    #
    # Since we may be running on a 32-bit platform, we can't just shove the
    # 64-bit dts in the :opaque pointer, so we have to alloc some space for the
    # address.  Instead of allocating and freeing repeatedly, we're going to
    # alloc it once now and reuse it for each decoded frame.
    @last_dts = nil
    @last_pos = nil
    @opaque = FFI::MemoryPointer.new :uint64, 2

    @av_codec_ctx[:get_buffer] = \
      FFI::Function.new(:int, [AVCodecContext.ptr, AVFrame.ptr]) do |ctx,frame|

        # Use the default method to get the buffer
        ret = avcodec_default_get_buffer(ctx, frame)

        # Update the :opaque field point at a copy of the last pts we've seen.
        @opaque.put_int64(0, @last_dts)
        @opaque.put_uint64(8, @last_pos)
        frame[:opaque] = @opaque

        ret
      end

    # Point at our fast frame seeking data, and set our update ffs variable to
    # true if any data was provided.
    @ffs = p[:ffs]
    @update_ffs = @ffs ? true : false

    # Initialize our frame number offset, and our pts offset.  These two are
    # modified by seek(), and used by decode_frame().
    @frame_offset = 0
    @pts_offset = 0
  end

  def fps
    @av_stream[:r_frame_rate].to_f
  end

  # Set the +width+ of the frames returned by +decode_frame+
  def width=(width)
    @width = width
    init_scaling
  end

  # Set the +height+ of the frames returned by +decode_frame+
  def height=(height)
    @height = height
    init_scaling
  end

  # Set the +pixel format+ of the frames returned by +decode_frame+
  def pixel_format=(pixel_format)
    @pixel_format = pixel_format
    init_scaling
  end

    # Called by Libav::Reader.each_frame to decode each frame
  def decode_frame(packet)
    # initialize_scaling unless @scaling_initialized

    @last_dts = packet[:dts]
    @last_pos = packet[:pos]

    avcodec_get_frame_defaults(@raw_frame.av_frame)
    rc = avcodec_decode_video2(@av_codec_ctx, @raw_frame.av_frame,
                               @frame_finished, packet)

    return nil if rc < 0
    raise RuntimeError, "avcodec_decode_video2() failed, rc=#{rc}" if rc < 0
    return if @frame_finished.read_int == 0
    @seen = []

    @raw_frame.number = @av_codec_ctx[:frame_number].to_i + @frame_offset
    @raw_frame.pts = @raw_frame.av_frame[:opaque].get_int64(0) + @pts_offset
    @raw_frame.pos = @raw_frame.av_frame[:opaque].get_uint64(8)

    # Update the fast-frame-seek data if:
    # - we are tracking FFS
    # - the FFS data hasn't been frozen due to a seek()
    # - the frame we decoded is a key frame
    # - the frame number is higher than the last frame in the FFS data
    #
    # The last point is there because we may be handed partial FFS data and
    # then start reading the file to come up with the rest.
    #
    # XXX The frozen part may change if we can use FFS data from a previous run
    # to determine the frame number offset after seek().
    @ffs << [ @raw_frame.number, @raw_frame.pts, @raw_frame.pos ] if 
      @raw_frame.key_frame? and @update_ffs and
      (@ffs.empty? or @raw_frame.number > @ffs.last[0])

    return @raw_frame unless @swscale_ctx

    @raw_frame.scale(:scale_ctx => @swscale_ctx,
                     :output_frame => @scaled_frame)
  end

  private

  def init_scaling
    sws_freeContext(@swscale_ctx) unless @swscale_ctx.nil?
    @swscale_ctx = nil
    @scaled_frame = nil

    return if @width == @av_codec_ctx[:width] &&
              @height == @av_codec_ctx[:height] &&
              @pixel_format == @av_codec_ctx[:pix_fmt]

    @swscale_ctx = sws_getContext(@av_codec_ctx[:width],
                                  @av_codec_ctx[:height],
                                  @av_codec_ctx[:pix_fmt],
                                  @width, @height, @pixel_format,
                                  SWS_BICUBIC, nil, nil, nil) or
      raise NoMemoryError, "sws_getContext() failed"

    @scaled_frame = Libav::Frame::Video.new(:width => @width,
                                            :height => @height,
                                            :pixel_format => @pixel_format,
                                            :stream => self)
  end
end

class Libav::Stream::Unsupported
  include Libav::Stream

  def initialize(p={})
    super(p)
    self.discard = :all
  end
end
