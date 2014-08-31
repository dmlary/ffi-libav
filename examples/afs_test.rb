#!/usr/bin/env ruby
#
# Simple program that reads the first 1000 frames of a video file, then uses
# AFS to seek to each frame and verify that the seeked frame matches our
# original frame.  Frame comparison done using crc.

$: << File.join(File.dirname(__FILE__), "..", "lib")
require 'ffi-libav'
require 'zlib'
require 'pp'

# We use this to verify that we got back to the same frame
class Libav::Frame::Video
  def crc
    height.times.inject(0) do |crc,row|
      Zlib::crc32(data[0].get_bytes(linesize[0] * row, width), crc)
    end
  end
end

def format_seconds(s)
  s = s.to_i
  h = s/3600
  s -= h * 3600
  m = s/60
  s -= m * 60
  "%02d:%02d:%02d" % [ h, m, s ]
end

GLYPHS = %w{ | / - \\ }
@first = nil
@last  = nil
@calls = 0
def spin(frame)
  now = Time.now()
  @first ||= now
  @last  ||= now

  @calls += 1

  if (@last + 0.25 < now)
    fps = @calls.to_f / (now - @first)
    pos = frame.number / frame.stream.fps.to_f
    printf("\r[%s] %0.03f fps, frame: %d, pts %d, pos: %s",
            format_seconds(now - @first), fps, frame.number, frame.pts, 
            format_seconds(pos))
    @last = now
  end
end

# open our video file
reader = Libav::Reader.new(ARGV[0], :afs => true)
reader.dump_format

# Read through the default stream until we get say 100 key frames in our
# accurate frame seek data.
stream = reader.default_stream
crc = []
stream.each_frame do |frame|
  spin(frame)
  crc[frame.number] = frame.crc
  break if crc.size > 999
end
puts ""

# Save off the AFS data, and create a new reader with it
afs = reader.afs
reader = Libav::Reader.new(ARGV[0], :afs => afs)
stream = reader.default_stream

# Shuffle our frame numbers, and seek to each one.
crc.size.times.to_a.shuffle.each_with_index do |number, attempt|
  STDOUT.write "%3d: frame %3d, " % [attempt, number]
  STDOUT.flush
  begin
    # Perform the seek
    stream.seek(:frame => number)
  rescue Libav::Stream::FrameNotFound => e
    # This can happen for some codeds
    puts "warn -- inaccessable frame; #{e}"
    next
  end

  # Verify the frame data matches our original pass
  frame = stream.next_frame
  frame_crc = frame.crc
  if (crc[number] != frame_crc)
    puts "FAILED -- got %08x, expected %08x" % [frame_crc, crc[number]]
  else
    puts "pass"
  end
end
