require 'ffi/libav'

# Libav file reader
class Libav::Reader
  extend Forwardable
  include FFI::Libav

  attr_reader :filename, :streams, :av_format_ctx, :afs
  def_delegator :@av_format_ctx, :[], :[]

  # Open a Libav::Reader and yield it to the caller
  def self.open(filename, p={}, &block)
    yield new(filename, p)
  end

  # Initialize a Reader for a specific file
  #
  # ==== Attributes
  # * +filename+ - file to read
  #
  # ==== Options
  # * +:afs+ - Enable and supply fast-frame-seek data (default: false)
  #
  # ==== Usage
  #   # open a file named 'video.ts' for reading
  #   r = Libav::Reader.new("video.ts")
  #
  #   # open the same video and enable AFS
  #   r = Libav::Reader.new("video.ts", :afs => true)
  #   r.each_frame { |f| do_something(f) }
  #
  #   # After reading any portion of the file, save the AFS data
  #   File.open("video_afs.yml", "w") do |file|
  #     file.write(r.afs.to_yaml)
  #   end
  #
  #   # open a video file and use AFS data from a previous run
  #   afs = Yaml.load_file("video_afs.yml")
  #   r = Libav::Reader.new("video.ts", :afs => afs)
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

    # Fast frame seeking data; initialize it if @afs is enabled, but no data
    # has been provided.
    @afs = p[:afs]
    @afs = Array.new(@av_format_ctx[:nb_streams]) {[]} if @afs == true

    # Open all of our streams
    initialize_streams(p)

    # Set up a finalizer to close all the things we've opened
    ObjectSpace.define_finalizer(self,
      cleanup_proc(@av_format_ctx, streams.map { |s| s.av_codec_ctx }))

    # Our packet for reading
    @packet = AVPacket.new
    av_init_packet(@packet)

    # output frame buffer; used for #rewind
    @output_frames = []

    # This is our rewind queue, frames from @output_frame get stuck on here
    # by #rewind, and shifted off by #each_frame
    @rewound = []
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
  # ==== Options
  # * +:stream+ stream index or indexes to get frames for
  # * +:buffer+ number of frames to buffer in each stream
  #
  # ==== Usage
  #   # Read each frame
  #   reader.each_frame do |frame|
  #
  #     # call some method for showing the frame
  #     my_show_frame(frame)
  #   end
  #
  def each_frame(p={}, &block)
    raise ArgumentError, "No block provided" unless block_given?

    # Patch up the :stream argument
    p[:stream] ||= @streams.map { |s| s[:index] }
    p[:stream] = [ p[:stream] ] unless p[:stream].is_a? Array

    # Notify each stream of the requested buffer size
    p[:stream].each { |i| @streams[i].buffer = p[:buffer] if p[:buffer]}

    # If we have any frames on our @rewound list
    while frame = @rewound.shift
      @output_frames.push frame
      next if p[:stream].include? frame.stream
      break if yield(frame) == false
    end

    # Let's read frames
    while av_read_frame(@av_format_ctx, @packet) >= 0

      # Only call the decoder if the packet is from a stream we're interested
      # in.
      frame = nil
      frame = @streams[@packet[:stream_index]].decode_frame(@packet) if
        p[:stream].include? @packet[:stream_index]

      # release our packet memory
      av_free_packet(@packet)

      next unless frame

      # Before yielding the frame, add it to our output list for rewind
      @output_frames.push frame

      yield frame
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

  # Rewind the reader
  #
  # This method will rewind the reader at most +count+ frames for the whole
  # file, or for the +:stream+ provided.  If not enough frames are available,
  # rewind() will rewind as many as possible.
  #
  # After calling #rewind, #each_frame will yield frames
  #
  # Arguments:
  #   +count+ Number of frames to rewind
  #
  # Options:
  #   +:stream+ [optional] stream +count+ applies to
  #
  # Return:
  #   Number of frames for stream that were rewound
  def rewind(count=nil, p={})

    # Reduce our output frames based on any :stream provided
    frames = @output_frames.select do |frame|
      p[:stream].nil? or frame.stream == p[:stream]
    end

    # Cap the count at the number of frames we can rewind
    count = frames.size if count.nil? or count > frames.size

    # find the count-th frame from the end of our reduced frame array.
    frame = frames[-1 * count.to_i]

    # Find the index of that frame in the real output frames array
    index = @output_frames.find_index(frame) or return 0

    # Split the output frames into two arrays, those that have been yielded
    # (output_frames), and those that have been rewound (rewound)
    @rewound = (@output_frames.slice!(index, @output_frames.size) || []) +
      @rewound

    # Flush the buffer of every stream we rewound.  We need to do this because
    # other threads may have references to some of the frames we rewound.  If
    # it were possible to reverse Libav::Stream#release_frame, there would
    # still be a problem if another thread released one of our rewound frames
    # before it was yielded by #each_frame.
    #
    # The solution to this problem is to have each stream clear all of their
    # frame buffers.  The next time the stream decodes a frame, it will have to
    # allocate a new buffer.  Expensive, but this shouldn't happen very often.
    @rewound.map { |f| f.stream }.uniq.each { |s| s.release_all_frames }
  
    # Return the number of frames rewound for the requested stream.  If no
    # stream were requested, this would be the total number of frames rewound.
    frames.size - frames.find_index(frame)
  end

  # This method is used to notify the Reader that the frame is about to be
  # modified.  This call is used to update the output buffer that is used
  # by #rewind.  The supplied frame, and all preceding frames are dropped from
  # the output buffer.  This reduces how far we can rewind.
  def frame_dirty(frame)
    index = @output_frames.index(frame) or return
    @output_frames.shift(index + 1)
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
                                 :afs => @afs && @afs[av_stream[:index]])
      else
        Libav::Stream::Unsupported.new(:reader => self,
                                        :av_stream => av_stream)
      end
    end
  end
end
