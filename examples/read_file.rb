#!/usr/bin/env ruby

$: << File.join(File.dirname(__FILE__), "..", "lib")
require 'ffi-libav'
require 'pp'

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
reader = Libav::Reader.new(ARGV[0])
reader.dump_format

# Find the first video stream
reader.streams.each { |s| s.discard == :all }
stream = reader.default_stream
stream.discard = :default
# stream.buffer_size = 2
stream.each_frame { |frame| spin frame}
