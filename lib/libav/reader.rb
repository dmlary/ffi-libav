require 'ffi/libav'

# Libav file reader
class Libav::Reader
  extend Forwardable
  include FFI::Libav

  attr_reader :filename, :streams, :av_format_ctx, :ffs
  def_delegator :@av_format_ctx, :[], :[]

  # Initialize a Reader for a specific file
  #
  # ==== Attributes
  # * +filename+ - file to read
  #
  # ==== Options
  # * +:ffs+ - Enable and supply fast-frame-seek data (default: false)
  #
  # ==== Usage
  #   # open a file named 'video.ts' for reading
  #   r = Libav::Reader.new("video.ts")
  #
  #   # open the same video and enable FFS
  #   r = Libav::Reader.new("video.ts", :ffs => true)
  #   r.each_frame { |f| do_something(f) }
  #   
  #   # After reading any portion of the file, save the FFS data
  #   File.open("video_ffs.yml", "w") do |file|
  #     file.write(r.ffs.to_yaml)
  #   end
  #
  #   # open a video file and use FFS data from a previous run
  #   ffs = Yaml.load_file("video_ffs.yml")
  #   r = Libav::Reader.new("video.ts", :ffs => ffs)
  #
  def initialize(filename, p={})
    @filename = filename or raise ArgumentError, "No filename"

    Libav.register_all
    @av_format_ctx = FFI::MemoryPointer.new(:pointer)
    rc = avformat_open_input(@av_format_ctx, @filename, nil, nil)
    raise RuntimeError, "avformat_open_input() failed, filename='%s', rc=%d" %
      [filename, rc] if rc != 0
    @av_format_ctx = AVFormatContext.new @av_format_ctx.get_pointer(0)

    rc = avformat_find_stream_info(@av_format_ctx, nil)
    raise RuntimeError, "av_find_stream_info() failed, rc=#{rc}" if rc < 0

    # Open all of our streams
    initialize_streams(p)

    # Set up a finalizer to close all the things we've opened
    ObjectSpace.define_finalizer(self,
      cleanup_proc(@av_format_ctx, streams.map { |s| s.av_codec_ctx }))

    # Our packet for reading
    @packet = AVPacket.new
    av_init_packet(@packet)

  end

  # Call +av_dump_format+ to print out the format info for the video
  def dump_format
    FFI::Libav.av_dump_format(@av_format_ctx, 0, @filename, 0)
  end

  # Video duration in (fractional) seconds
  def duration
    @duration ||= @av_format_ctx[:duration].to_f / AV_TIME_BASE
  end

  # Loop through each frame
  #
  # ==== Argument
  # * +block+ - block of code to call with the frame
  #
  # ==== Usage
  #   # Read each frame
  #   reader.each_frame do |frame|
  #
  #     # call some method for showing the frame
  #     my_show_frame(frame)
  #   end
  #
  def each_frame(&block)
    raise ArgumentError, "No block provided" unless block_given?

    while av_read_frame(@av_format_ctx, @packet) >= 0
      frame = @streams[@packet[:stream_index]].decode_frame(@packet)
      av_free_packet(@packet)
      rc = frame ? yield(frame) : true
      break if rc == false
    end
  end

  # Get the default stream
  def default_stream
    @streams[av_find_default_stream_index(@av_format_ctx)]
  end

  # See Libav::Stream.seek
  def seek(p = {})
    default_stream.seek(p)
  end

  private

  # Generate the Proc that is responsible for releasing our avcodec, avformat
  # structures.
  def cleanup_proc(codecs, format)
    proc do
      codecs.each { |codec| avcodec_close codec }
      avformat_close_input(format)
    end
  end

  # Lookup and initialize the streams
  def initialize_streams(p={})

    # Initialize our ffs variable if needed
    @ffs = p[:ffs]
    @ffs = Array.new(@av_format_ctx[:nb_streams]) { [] } if @ffs == true

    @streams = @av_format_ctx[:nb_streams].times.map do |i|
      av_stream = AVStream.new \
            @av_format_ctx[:streams].get_pointer(i * FFI::Pointer::SIZE)
      av_codec_ctx = av_stream[:codec]

      case av_codec_ctx[:codec_type]
      when :video
        Libav::Stream::Video.new(:reader => self,
                                  :av_stream => av_stream,
                                  :pixel_format => p[:pixel_format],
                                  :width => p[:width],
                                  :height => p[:height],
                                  :ffs => @ffs && @ffs[av_stream[:index]])
      else
        Libav::Stream::Unsupported.new(:reader => self,
                                        :av_stream => av_stream)
      end
    end
  end
end
