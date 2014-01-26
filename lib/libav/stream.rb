require 'ffi/libav'

module Libav::Stream
  include FFI::Libav

  attr_reader :reader, :av_stream, :av_codec_ctx

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

  def each_frame
    @reader.each_frame { |frame| yield frame if frame.stream == self }
  end

  def next_frame
    frame = nil
    each_frame { |f| frame = f; break }
    frame
  end

  def skip_frames(n)
    raise RuntimeError, "Cannot skip frames when discarding all frames" if
      discard == :all
    each_frame { |f| n -= 1 != 0 }
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

    raise ArgumentError, ":pts and :pos are mutually exclusive" \
      if p[:pts] and p[:pos]

    pos = p[:pts] || p[:pos]
    flags = 0
    flags |= AVSEEK_FLAG_BYTE if p[:pos]
    flags |= AVSEEK_FLAG_BACKWARD if p[:backward]
    flags |= AVSEEK_FLAG_ANY if p[:any]

    rc = av_seek_frame(@reader.av_format_ctx, @av_stream[:index], pos, flags)
    raise RuntimeError, "av_seek_frame() failed, %d" % rc if rc < 0
    true
  end
end

class Libav::Stream::Video
  include Libav::Stream

  attr_reader :raw_frame, :width, :height, :pixel_format, :reader

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
    @opaque = FFI::MemoryPointer.new :uint64

    @av_codec_ctx[:get_buffer] = \
      FFI::Function.new(:int, [AVCodecContext.ptr, AVFrame.ptr]) do |ctx,frame|

        # Use the default method to get the buffer
        ret = avcodec_default_get_buffer(ctx, frame)

        # Update the :opaque field point at a copy of the last pts we've seen.
        @opaque.write_int64 @last_dts
        frame[:opaque] = @opaque

        ret
      end
  end

  def fps
    @av_stream[:r_frame_rate]
  end

  def width=(width)
    @width = width
    init_scaling
  end

  def height=(height)
    @height = height
    init_scaling
  end

  def pixel_format=(pixel_format)
    @pixel_format = pixel_format
    init_scaling
  end

  def decode_frame(packet)
    # initialize_scaling unless @scaling_initialized

    @last_dts = packet[:dts]
    avcodec_get_frame_defaults(@raw_frame.av_frame)
    rc = avcodec_decode_video2(@av_codec_ctx, @raw_frame.av_frame,
                               @frame_finished, packet)
    raise RuntimeError, "avcodec_decode_video2() failed, rc=#{rc}" if rc < 0
    return if @frame_finished.read_int == 0

    @raw_frame.pts = @raw_frame.av_frame[:opaque].read_int64
    @raw_frame.number = @av_codec_ctx[:frame_number].to_i

    return @raw_frame unless @swscale_ctx

    @raw_frame.scale(:width => @width, :height => @height,
                     :pixel_format => @pixel_format,
                     :scale_ctx => @swscale_ctx,
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
