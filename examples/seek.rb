#!/usr/bin/env ruby

require 'pp'
$: << File.join(File.dirname(__FILE__), "..", "lib")
require 'ffi-libav'

def write_frame(filename, frame)
  file = File.new(filename, "w")
  file.write "P6\n%d %d\n255\n" % [frame.width, frame.height]

  data = frame.data[0]
  linesize = frame.linesize[0]
  bytes_per_row = 3 * frame.width

  frame.height.times do |row|
    file.write data.slice(row * linesize, bytes_per_row)\
                   .read_string_length(bytes_per_row)
  end
  file.close
end

# Open our video file
reader = Libav::Reader.new(ARGV[0], :pixel_format => :rgb24)
stream = reader.default_stream

# Find the first video stream
reader.streams.each { |s| s.discard = :all unless s == stream }
stream.discard = :nonkey

count = ARGV[1] ? ARGV[1].to_i : 10
step = File.size(ARGV[0]) / (count + 2)

count.times do |i|
  i += 1
  puts "Seeking to %d" % (i * step)
  stream.seek(:pos => i * step)

  frame = stream.next_frame
  pp :frame => frame.pts

  # For some reason, when working on MPEG-TS files, following the seek,
  # the packet DTS of the next packet read is -1 * AV_NOPTS_VALUE.  When
  # we save that frame it looks like a stale buffer.  So we want to skip
  # the frame if the pts is this value.  Also only accept key frames.
  until frame.key_frame? # and frame.pts == 0
    frame = stream.next_frame
  end
  puts "Saving frame %d, pts %d" % [ frame.number, frame.pts ]
  write_frame("seek-%02d.ppm" % i, frame)
end
