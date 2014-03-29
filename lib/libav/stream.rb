require 'ffi/libav'
require 'thread'

# Generic Stream class.  Most of the logic resides in Libav::Stream::Video.
module Libav::Stream
  extend Forwardable
  include FFI::Libav

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
  # s.each_frame(:buffer => 10) do |frame|
  #   queue_frame(frame)
  # end
  #
  # def queue_frame(f)
  #   # process
  #   f.finished
  # end
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
  # XXX Need some way to note which portion of the video file is covered by the
  # ffs data.  This should include max frame number, max pts.  If the requested
  # location is outside the region covered by the FFS data, we should let libav
  # figure out where to go.
  #
  # Last index of ffs data should contain last frame read.
  def seek(p={})

    raise ArgumentError, "Invalid arguments" if
      ([:byte, :frame, :pts] & p.keys).size != 1
    raise ArgumentError, ":frame not supported without ffs data" if
      p[:frame] and @ffs.nil?

    # ffs will hold the ffs entry we used for performing the byte seek.  It is
    # used after we call av_seek_frame() to adjust offsets.
    ffs = nil

    # If they passed in a :pts or :frame argument, and we have ffs data, use
    # the ffs data to come up with a byte offset for seeking.
    if p[:byte].nil? and @ffs

      # Find the last ffs entry before the requested location.  Since the ffs
      # data contains the key frame information, we're finding the byte offset
      # of the last key frame before the requested position.
      index = @ffs.rindex do |data|
        p[:frame] && data[0] < p[:frame] or p[:pts] && data[1] < p[:pts]
      end

      # If we found an entry, and it's not the last entry in our ffs data, we
      # will pull the byte offset from the record and use that for seeking.  We
      # also save off the ffs entry here for use after the call to
      # av_seek_frame().
      # Note that it is possible for index to be nil, in the case where the
      # caller is looking for a frame before the first key frame in our ffs
      # data.
      if index and index < @ffs.size - 1
        ffs = @ffs[index]
        p[:byte] = ffs[2]
      end

      # If the byte isn't set by now, and the caller passed in a frame number,
      # then we should raise an error saying we can't find the requested
      # location.
      raise RuntimeError, "Unable to find frame #{p[:frame]} in ffs data" if
        p[:frame] and p[:byte].nil?

    end

    # Alright, if we have a :byte argument, we'll pass that to av_seek_frame(),
    # otherwise we'll pass the :pts argument.  :frame would have already been
    # resolved by this point.

    # Let's construct our flags to av_seek_frame
    flags = 0
    flags |= AVSEEK_FLAG_BYTE if p[:byte]
    flags |= AVSEEK_FLAG_BACKWARD if p[:backward]
    flags |= AVSEEK_FLAG_ANY if p[:any]

    # Kick off our seek
    rc = av_seek_frame(@reader.av_format_ctx, @av_stream[:index],
                       p[:byte] || p[:pts], flags)
    raise RuntimeError, "av_seek_frame() failed, %d" % rc if rc < 0

    # If we performed an ffs seek, we need to enable ffs data updating, and if
    # not we need to disable it.
    @update_ffs = (ffs != nil)

    # We also need to clear the frame and pts offsets.  If this is a ffs seek,
    # these will be re-set to their new values later.
    @frame_offset = 0
    @pts_offset = 0

    # If this wasn't an ffs seek, return now
    return true unless ffs

    # This was an ffs seek, so we've just moved the file position to the start
    # of the last key frame before the requested frame.  We need to now read
    # this key frame, and adjust our frame and pts offset values to account for
    # the codec not knowing where we really are.
    frame = next_frame
    @frame_offset = -1 * (frame.number - ffs[0])
    @pts_offset = -1 * (frame.pts - ffs[1])

    # Now that we have corrected offsets, we need to read the next few frames
    # until we encounter the requested frame or a frame after it (possible for
    # pts values that are slightly off).
    each_frame(:buffer => 2) do |frame|
      break if p[:frame] and frame.number >= p[:frame]
      break if p[:pts] and frame.pts >= p[:pts]
    end

    # XXX we need to make changes to the Stream to support buffering of frames
    # during encode.  This is so that if we encounter a frame after our desired
    # pts, we can return the frame before it, which would have to be buffered
    # some place.  Buffer should be thread safe, implemented in Stream.
    # decode_frame should know if we're buffering, if we're not it will manage
    # push/pop on Queue, if we are buffering, caller will need to handle that
    # behavior.
    #
    # We should buffer only the scaled frames.  If we buffered only the raw
    # frames, we'd still need to provide a buffer of scaled frames for the
    # caller to work on two frames at once.  So we wouldn't be able to just
    # buffer the raw frames.

    return true
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
    raw_frame = @raw_queue.pop

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

    raw_frame.number = @av_codec_ctx[:frame_number].to_i + @frame_offset
    raw_frame.pts = raw_frame.av_frame[:opaque].get_int64(0) + @pts_offset
    raw_frame.pos = raw_frame.av_frame[:opaque].get_uint64(8)

    # If we're scaling, or not buffering, throw the raw frame back on the
    # queue; it's the only one we have
    @raw_queue.push raw_frame if @swscale_ctx or @buffer == 0

    # If we're not scaling at this point, we need to return the raw frame to
    # the caller.  This is the non-buffering, non-scaling return point.
    return raw_frame unless @swscale_ctx

    # Let's grab a scaled frame from our queue
    scaled_frame = @scaled_queue.pop

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
