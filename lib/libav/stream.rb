require 'ffi/libav'
require 'thread'

# Generic Stream class.  Most of the logic resides in Libav::Stream::Video.
module Libav::Stream
  extend Forwardable
  include FFI::Libav

  # Exception raised by Stream#seek when an AFS seek is unable to find the
  # target frame.  This can happen for some codecs such as MPEG-TS when
  # attempting to access the earliest frames.
  class FrameNotFound < Exception; end

  attr_reader :reader, :av_stream, :av_codec_ctx, :buffer
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

  # Loop through each frame of this stream
  #
  # Arguments:
  #   [:buffer]   Number of frames to buffer
  #
  # Note that when using the :buffer argument, the caller MUST call
  # Frame#release when it is done processing a frame.
  #
  def each_frame(opt={}, &block)
    @reader.each_frame(opt.merge({ :stream => index }), &block)
  end

  # Get the next frame in the stream
  def next_frame
    each_frame { |f| break f }
  end

  # Skip some +n+ frames in the stream
  def skip_frames(n)
    # XXX not sure if this is true
    raise RuntimeError, "Cannot skip frames when discarding all frames" if
      discard == :all
    each_frame { |f| f.release; n -= 1; break if n == 0}
  end

  # Seek to a specific location within the stream; the location can be either
  # a PTS value or an absolute byte position.
  #
  # Arguments:
  #   [:pts]  PTS location
  #   [:byte]  Byte location
  #   [:backward] Seek backward
  #   [:any]  Seek to non-key frames
  #
  # Examples:
  #   seek :frame => 3
  #   seek :pts => 90218390
  #   seek :pos => 0
  #
  # Last index of afs data should contain last frame read.
  def seek(p={})

    raise ArgumentError, ":pts, :frame, and :byte are mutually exclusive" if
      ([:byte, :frame, :pts] & p.keys).size != 1

    # Default seek arguments
    flags = p[:backward] ? AVSEEK_FLAG_BACKWARD : 0
    flags |= AVSEEK_FLAG_BYTE if p[:byte]
    flags |= AVSEEK_FLAG_FRAME if p[:frame]
    flags |= AVSEEK_FLAG_ANY if p[:any]
    seek_args = [[p[:pts] || p[:frame] || p[:byte], flags]]

    # If we have afs data, and our target frame is within the data, replace
    # seek_args with an array of arguments for seeking to each key frame
    # preceding our target frame, in reverse-chronological order.  The idea is
    # that sometimes libav seek puts us someplace strange.  If we start at the
    # closest key frame to our target frame, and the work backwards in the
    # stream, libav will eventually put us in a place where we can read to the
    # target frame.
    if @afs and !@afs.empty? and
        (p[:frame] && p[:frame] <= @afs.last[0] or
         p[:pts]   && p[:pts]   <= @afs.last[1] or
         p[:byte]  && p[:byte]  <= @afs.last[2])

      # Note that we set the flags to AVSEEK_FLAG_BACKWARD for each of our arg
      # sets.  This is just because by observation the BACKWARD flag seems to
      # give us better results regardless of the direction of our seek.
      seek_args = @afs.select do |data|
          p[:frame] && data[0] < p[:frame] or
            p[:pts] && data[1] < p[:pts] or
            p[:byte] && data[2] && data[2] < p[:byte]
        end.map { |d| [ d[1], AVSEEK_FLAG_BACKWARD, true ] }.reverse

      # Throw the seek 0 into the end of the list as a fall back
      seek_args.push [0, AVSEEK_FLAG_BACKWARD, true]
    end

    # Disable afs updating because we're about to seek.  If the seek ends up
    # within our afs data, it will be re-enabled.
    @update_afs = false

    # We will fill this frame in the next loop, and use it after the loop is
    # complete.
    frame = nil

    # Loop through each set of arguments provided.  Seek to the timestamp in
    # the arguments and then verify that we haven't gone past our target.
    seek_args.each do |ts, flags, afs|

      # Flush the codec so we don't get buffered frames after the seek
      avcodec_flush_buffers(@av_codec_ctx)

      # Kick off our seek
      rc = avformat_seek_file(@reader.av_format_ctx, @av_stream[:index],
                              ts, ts, ts, flags)
      raise RuntimeError, "avformat_seek_file(#{ts}, #{flags.to_s(16)})" +
        " failed, #{rc}" if rc < 0

      # If we performed an afs seek, we need to enable afs data updating, and
      # if not we need to disable it.
      @update_afs = (afs == true)

      # We also need to clear the frame and pts oafsets.  If this is a afs
      # seek, these will be re-set to their new values later.
      @frame_oafset = 0
      @pts_oafset = 0

      # If this wasn't an afs seek, we are done here.
      return true unless afs

      # Grab the next frame, and see if it precedes, or is, our target frame.
      # If no frame is returned, we hit EOF, so try seeking a little earlier.
      frame = next_frame or next
      frame.release

      # Although the code is only needed in this loop when we're seeking by
      # :frame, we're going to adjust our frame oafset here.  It's a little
      # slower, but less complicated overall.
      #
      # Find the afs entry for this frame (it's guaranteed to be a key
      # frame), and use that to adjust the number of the frame we just read.
      #
      # If we're unable to find a match in the afs data, then we've gone past
      # the end of the afs data, and we should try another seek timestamp.
      seek_afs = @afs.find { |f| f[1] == frame.pts } or next
      raise RuntimeError, "afs data mismatch: afs #{seek_afs}, " +
          "frame [#{frame.number}, #{frame.pts}, #{frame.pos}]" if
        frame.pos != seek_afs[2]

      # Adjust our frame oafset, and use that to adjust our frame number
      @frame_oafset = -1 * (frame.number - seek_afs[0])
      frame.number += @frame_oafset

      # If this frame precedes or is our target frame, then the seek was
      # successful, and we can break out of this loop.
      break if p[:pts] && p[:pts] >= frame.pts or
        p[:frame] && p[:frame] >= frame.number or
        p[:byte] && p[:byte] >= frame.pos

      # This frame was after our target frame, so ignore it.
      frame = nil
    end

    # If we went through all the seek_args without finding a single frame
    # before our target frame, throw an exception.
    unless frame
      mode = (p.keys & [:pts, :frame, :byte]).first
      raise FrameNotFound, "Unable to find frame {%s: %d}" % [mode, p[mode]]
    end

    # Rewind the frame so we can access it in the next loop
    rewind(1)

    # Also mark afs as updating because we're within the known afs data region.
    @update_afs = true

    # Now that we have corrected oafsets, we need to read the next few frames
    # until we encounter the target frame or a frame after it (possible for
    # pts values that are slightly off).
    each_frame do |frame|
      frame.release
      break if p[:pts] && frame.pts >= p[:pts] or
        p[:frame] && frame.number >= p[:frame] or
        p[:byte] && frame.pos >= p[:byte]
    end

    # Alright, let's rewind by one frame so the next call to #each_frame will
    # yield the frame they requested.
    rewind(1)

    return true
  end

  def format_afs(a)
    "{frame: %d, pts: %d, pos: %d}" % [*a]
  end
end

class Libav::Stream::Video
  include Libav::Stream

  attr_reader :width, :height, :pixel_format, :reader, :afs

  def initialize(p={})
    super(p)

    # Handle frame width and height and setup any scaling necessary
    @width  = p[:widht]  || @av_codec_ctx[:width]
    @height = p[:height] || @av_codec_ctx[:height]
    @pixel_format = p[:pixel_format] || @av_codec_ctx[:pix_fmt]

    # Our stream index info
    @afs = p[:afs]
    @update_afs = @afs.nil? == false

    # Our array and queues for raw frames and scaled frames
    @raw_frames = []
    @raw_queue = Queue.new
    @scaled_frames = []
    @scaled_queue = Queue.new

    # Number of frames to buffer (default is disabled, 0)
    @buffer = 0

    # When this is set to true when all raw and scaled frames have been set up
    # by setup().
    @decode_ready = false

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

    # Initialize our frame number oafset, and our pts oafset.  These two are
    # modified by seek(), and used by decode_frame().
    @frame_oafset = 0
    @pts_oafset = 0

  end

  def fps
    @av_stream[:r_frame_rate].to_f
  end

  # Set the +width+ of the frames returned by +decode_frame+
  def width=(width)
    return if width == @width
    @width = width
    teardown
  end

  # Set the +height+ of the frames returned by +decode_frame+
  def height=(height)
    return if height == @height
    @height = height
    teardown
  end

  # Set the +pixel format+ of the frames returned by +decode_frame+
  def pixel_format=(pixel_format)
    return if pixel_format == @pixel_format
    @pixel_format = pixel_format
    teardown
  end

  # Set the buffer size
  def buffer=(v)
    return if v == @buffer
    @buffer = v
    teardown
  end

  # Check to see if this frame is being scaled
  def scaling?
    @av_codec_ctx[:width] != @width or
      @av_codec_ctx[:height] != @height or
      @av_codec_ctx[:pix_fmt] != @pixel_format
  end

  # Called by Libav::Reader.each_frame to decode each frame
  def decode_frame(packet)
    setup unless @decode_ready

    # Save off our dts and pos for the buffer allocation callback we declared
    # in #initialize
    @last_dts = packet[:dts]
    @last_pos = packet[:pos]

    # Grab our raw frame off the raw frames queue.  This will block if the
    # caller is still using all the previous frames.
    raw_frame = @raw_queue.shift

    # Let the reader know we're stomping on this frame
    @reader.frame_dirty(raw_frame)

    # Call the decode function on our packet
    avcodec_get_frame_defaults(raw_frame.av_frame)
    rc = avcodec_decode_video2(@av_codec_ctx, raw_frame.av_frame,
                               @frame_finished, packet)

    # Now, if we didn't get a frame, for one reason or another, let's throw the
    # raw frame back on our queue.
    if rc < 0 or @frame_finished.read_int == 0
      @raw_queue.push raw_frame
      return nil
    end

    raw_frame.number = @av_codec_ctx[:frame_number].to_i + @frame_oafset
    raw_frame.pts = raw_frame.av_frame[:opaque].get_int64(0) + @pts_oafset
    raw_frame.pos = raw_frame.av_frame[:opaque].get_uint64(8)

    # AFS Data is broken down as follows:
    #   [ [frame number, pts, pos, true],   # entry for first key frame
    #     [frame number, pts, pos, true],   # entry for second key frame
    #     [frame number, pts, pos, true],   # entry for N-th key frame
    #     [frame number, pts, pos, false],  # optional, last non-key frame
    #   ]
    if @update_afs and (@afs.empty? or raw_frame.number > @afs.last[0])
      @afs.pop unless @afs.empty? or @afs.last[-1] == true
      @afs << [ raw_frame.number, raw_frame.pts,
                raw_frame.pos, raw_frame.key_frame? ]
    end

    # If we're scaling, or not buffering, throw the raw frame back on the
    # queue; it's the only one we have
    @raw_queue.push raw_frame if @swscale_ctx or @buffer == 0

    # If we're not scaling at this point, we need to return the raw frame to
    # the caller.  This is the non-buffering, non-scaling return point.
    return raw_frame unless @swscale_ctx

    # Let's grab a scaled frame from our queue
    scaled_frame = @scaled_queue.shift

    # Let the reader know we're stomping on this frame
    @reader.frame_dirty(scaled_frame)

    # scale the frame
    raw_frame.scale(:scale_ctx => @swscale_ctx,
                    :output_frame => scaled_frame)

    # Throw the scaled frame back on the queue if we're not buffering
    @scaled_queue.push scaled_frame if @buffer == 0

    scaled_frame
  end

  def release_frame(frame)
    @scaled_queue.push frame if @scaled_frames.include? frame
    @raw_queue.push frame if @raw_frames.include? frame
  end

  def rewind(count=nil)
    @reader.rewind(count, :stream => self)
  end

  # This method will make the stream release all references to buffered frames.
  # The buffers will be recreated the next time #decode_frame is called.
  def release_all_frames
    teardown
  end

  private

  # Initialize our raw and scaled frames along with our scaling context
  def setup
    return if @decode_ready

    # call teardown() now just to make sure everything is released
    teardown

    # If @buffer is set to zero, we aren't buffering, but we will need one raw
    # frame and one scaled frame.
    buffer = @buffer
    buffer += 1 if buffer == 0

    # Let's allocate our raw frames.  If we're scaling, we only need one raw
    # frame, otherwise we'll need more raw frames.
    ( scaling? ? 1 : buffer ).times do
      frame = Libav::Frame::Video.new :stream => self, :alloc => false,
                                      :width => @av_codec_ctx[:width],
                                      :height => @av_codec_ctx[:height],
                                      :pixel_format => @av_codec_ctx[:pix_fmt]
      @raw_frames.push frame
      @raw_queue.push frame
    end

    # If we're scaling, allocate our scaled frames and scaling context
    if scaling?

      # allocate our scaled frames
      buffer.times do
        frame = Libav::Frame::Video.new(:width => @width,
                                        :height => @height,
                                        :pixel_format => @pixel_format,
                                        :stream => self)
        @scaled_frames.push frame
        @scaled_queue.push frame
      end

      # Let's throw together a scaling context
      @swscale_ctx = sws_getContext(@av_codec_ctx[:width],
                                    @av_codec_ctx[:height],
                                    @av_codec_ctx[:pix_fmt],
                                    @width, @height, @pixel_format,
                                    SWS_BICUBIC, nil, nil, nil) or
        raise NoMemoryError, "sws_getContext() failed"
    end

    @decode_ready = true
  end

  # Release all references to our frames (raw & scaled), and free our scaling
  # context.
  def teardown
    @raw_frames.clear
    @raw_queue.clear
    @scaled_frames.clear
    @scaled_queue.clear
    sws_freeContext(@swscale_ctx) if @swscale_ctx
    @swscale_ctx = nil
    @decode_ready = false
  end
end

class Libav::Stream::Unsupported
  include Libav::Stream

  def initialize(p={})
    super(p)
    self.discard = :all
  end

  def buffer=(v)
    # nothing to be done here
  end

  def decode_frame(packet)
    return nil
  end
end
