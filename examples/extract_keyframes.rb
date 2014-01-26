#!/usr/bin/env ruby

$: << File.join(File.dirname(__FILE__), "..", "lib")
require 'ffi-libav'

def write_frame(filename, frame)
  file = File.new(filename, "w")
  file.write "P6\n%d %d\n255\n" % [frame.width, frame.height]

  data = frame.av_frame[:data][0]
  linesize = frame.av_frame[:linesize][0]
  bytes_per_row = 3 * frame.width

  frame.height.times do |row|
    file.write data.slice(row * linesize, bytes_per_row)\
                   .read_string_length(bytes_per_row)
  end
  file.close
end

# Open our video file
reader = Libav::Reader.new(ARGV[0], :pixel_format => :rgb24)

reader.dump_format
# Find the first video stream
stream = reader.streams.select { |s| s.discard = :all; s.type == :video } .first

# Tell the library to discard all non-key frames
stream.discard = :nonkey

# Write the first five key frames to disk
5.times do |i|
  frame = stream.next_frame
  write_frame("image-%d.ppm" % i, frame)
  puts "wrote frame %d" % frame.number
end

stream.pixel_format = :gray8

# Write the first five key frames to disk
5.times do |i|
  frame = stream.next_frame
  scaled = frame.scale(:width => 100, :height => 100, :pixel_format => :rgb24)
  write_frame("small-%d.ppm" % i, scaled)
  puts "wrote small frame %d" % scaled.number
end

