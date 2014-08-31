# FFI::Libav

Ruby FFI bindings and wrappers for Libav libraries, version 0.8.6.

## Installation

Add this line to your application's Gemfile:

    gem 'ffi-libav'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ffi-libav

## Basic Usage

```ruby
require 'ffi-libav'

# Allocate a reader for our video file
reader = Libav::Reader.new(ARGV[0])

# Dump the format information for the file
reader.dump_format

# Grab the first video stream in the file
stream = reader.streams.select { |s| s.type == :video }.first

# Loop through the key frames for the first video stream
stream.each_frame do |frame|
  # Do something interesting with the frame...
  # pixel data is in frame.data, linesizes are in frame.linesize
end
```

## Advanced Usage
In addition to the basic decoding of video frames, `ffi-libav` supports
buffered decoding, for multi-threaded frame processing, stream rewind support,
and accurate frame seeking.

### Buffered Read
Buffered decoding for Stream::Video#each_frame allows frame decoding
to happen independently of frame processing by providing a series of
frames for the stream instance to use while decoding.  As long as
frames are available to the stream, it will continue decoding.  The
caller must call Stream::Video#release_frame or Frame#release to
notify the Stream that yielded frames are no longer being used in
another thread.

```ruby
# Set up a work queue
frames = Queue.new

# Create 10 worker threads to perform some computationally expensive
# task on each frame, while not holding the GIL, think ffi opencv
running = true
threads = 10.times.map do
  while running

    # Grab a frame of the queue
    frame = frames.pop

    # Run something for a long time
    process_for_a_really_long_time(frame)

    # Release the frame so the stream can reuse it
    frame.release
  end
end

# In the main thread, let's read frames and throw them on the work
# queue.  #each_frame will block once it has decoded 20 frames, until one of
# the worker threads calls frame.release.
stream.each_frame(:buffer => 20) do |frame|
  frames.push frame
end
```

### Rewind
A simplified rewind capability has been implemented in conjunction with the
buffered decoding.  Libav::Reader will keep track of all frames released by the
stream, and if the caller calls Libav::Reader#rewind or Libav::Stream.rewind,
the Reader will rewind as many frame as possible, up to the number requested by
the caller.

NOTE: You can only rewind as many frames as have been buffered.  So if you have
no buffer set up, you can only call `rewind(1)` to get #next_frame to emit the
current frame again.

```ruby
# Decode frames, and buffer about 5 seconds worth (at 24 fps)
stream.each_frame(24 * 5) do |frame|

  # Check the frame to see if it matches something
  if frame_has_some_data?(frame)
    puts "match at %d, rewound %d frames" % [frame.number, rewind(24 * 5)]
    frame.release
    break
  end

  # Release the frame for reuse.  Note that releasing a frame DOES NOT mean
  # that it will be immediately overwritten.
  frame.release
end

# Now grab the frame from 5 seconds before we matched
frame = stream.next_frame
```

### Accurate Frame Seek (AFS)
Accurate Frame Seek (AFS) attempts to provide a reliable mechanism for seeking
accurately using libav.  It works by reading through the file once and
generating an index of frame numbers, pts, and file offset for each key frame.
It then uses these locations when seeking accurately.


```ruby
# open our video file
reader = Libav::Reader.new(ARGV[0], :afs => true)

# read all the frames; we do nothing with the data here, but this could be a
# first processing pass.
reader.default_stream.each_frame { }

# Save off our AFS data
afs = reader.afs

# Open the video file again, but supply the afs data this time
reader = Libav::Reader.new(ARGV[0], :afs => afs)

# Seek to a specific frame (by number)
begin
  reader.default_stream.seek { :frame => 100 }
rescue Libav::Stream::FrameNotFound => e
  # This can happen for the first few frames if the first frame is not a key
  # frame (MPEG-TS).
  puts "Unable to access frame 100"
end

# If the exception was not raised, the following call to #next_frame should
# give you the exact same data as you got for frame 100 on the first read.
frame = reader.default_stream.next_frame
```

A more indepth example can be found in `examples/afs_test.rb`.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/ffi-libav/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

