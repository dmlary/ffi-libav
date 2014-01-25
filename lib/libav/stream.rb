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

  attr_reader :raw_frame, :width, :height, :pixel_format, :buffer_size, :reader

  def initialize(p={})
    super(p)
    @width  = p[:widht]  || @av_codec_ctx[:width]
    @height = p[:height] || @av_codec_ctx[:height]
    @pixel_format = p[:pixel_format] || @av_codec_ctx[:pix_fmt]
    @buffer_size = p[:buffer_size] || 1

    @raw_frame = Libav::Frame::Video.new :stream => self,
                                          :width => @av_codec_ctx[:width],
                                          :height => @av_codec_ctx[:height],
                                          :pixel_format => 
                                            @av_codec_ctx[:pix_fmt]

    @frame_finished = FFI::MemoryPointer.new :int

    @scaling_initialized = false
    @swscale_ctx = nil
    @buffered_frames = nil
  end
    
  def fps
    @av_stream[:r_frame_rate]
  end

  def width=(width)
    @scaling_initialized = false
    @width = width
  end

  def height=(height)
    @scaling_initialized = false
    @height = height
  end

  def pixel_format=(pixel_format)
    @scaling_initialized = false
    @pixel_format = pixel_format
  end

  def buffer_size=(frames)
    @scaling_initialized = false
    @buffer_size = frames
  end

  def decode_frame(packet)
    initialize_scaling unless @scaling_initialized

    avcodec_get_frame_defaults(@raw_frame.av_frame)
    rc = avcodec_decode_video2(@av_codec_ctx, @raw_frame.av_frame,
                              @frame_finished, packet)
    raise RuntimeError, "avcodec_decode_video2() failed, rc=#{rc}" if rc < 0

    return if @frame_finished.read_int == 0

    @raw_frame.pts = 0 # @raw_frame.av_frame[:best_effort_timestamp]
    @raw_frame.number = @av_codec_ctx[:frame_number].to_i
    
    return @raw_frame unless @swscale_ctx

    # XXX Need to provide a better mechanism for making sure buffer is ready
    # for use.
    scaled_frame = @buffered_frames.shift
    @buffered_frames << scaled_frame

    @raw_frame.scale(:width => @width, :height => @height,
                     :pixel_format => @pixel_format,
                     :scale_ctx => @swscale_ctx,
                     :output_frame => scaled_frame)
  end

  private

  def initialize_scaling
    @scaling_initialized = true
    @swscale_ctx = nil
    @buffered_frames = nil

    return if @width == @av_codec_ctx[:width] &&
              @height == @av_codec_ctx[:height] &&
              @pixel_format == @av_codec_ctx[:pix_fmt] &&
              @buffer_size < 2

    @buffered_frames = @buffer_size.times.map do
      Libav::Frame::Video.new :stream => self,
                               :width => @width, 
                               :height => @height,
                               :pixel_format => @pixel_format
    end

    @swscale_ctx = sws_getContext(@av_codec_ctx[:width], 
                                  @av_codec_ctx[:height],
                                  @av_codec_ctx[:pix_fmt],
                                  @width, @height, @pixel_format,
                                  SWS_BICUBIC, nil, nil, nil) or
      raise NoMemoryError, "sws_getContext() failed"
  end
end

class Libav::Stream::Unsupported
  include Libav::Stream

  def initialize(p={})
    super(p)
    self.discard = :all
  end
end
