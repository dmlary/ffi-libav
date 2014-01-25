require 'ffi/libav'

module Libav::Frame; end

class Libav::Frame::Video
  include FFI::Libav

  attr_reader :av_frame, :stream
  attr_accessor :number

  def initialize(p={})
    @stream = p[:stream]
    width   = p[:width]  || @stream && @stream.width
    height  = p[:height] || @stream && @stream.height
    pixel_format = p[:pixel_format] || @stream && @stream.pixel_format

    # Create our frame and alloc space for the frame data
    @av_frame = AVFrame.new
    av_picture = AVPicture.new @av_frame.pointer
    avpicture_alloc(av_picture, pixel_format, width, height)
    pp :alloc => av_picture
    pp :picture => av_picture.to_hash
    pp :data => av_picture[:data].to_a

    # Set up our finalizer which calls av_free() on the av_frame.
    ObjectSpace.define_finalizer(self, self.class.finalize(av_picture))
  end

  def self.finalize(picture)
    proc { pp :xfree => picture; FFI::Libav.avpicture_free(picture) }
  end

  # Throw together a bunch of helper methods for accessing the AVFrame
  # attributes.
  AVFrame.members.each do |member|
    define_method(member) { @av_frame[member] }
    define_method(member.to_s + "=") { |v| @av_frame[member] = v }
  end

  def key_frame?
    key_frame == 1
  end

  def pixel_format
    format.is_a?(Fixnum) ? PixelFormat[format] : format
  end

  def pixel_format=(v)
    send("format=", (v.is_a?(Fixnum) ? v : PixelFormat[v]))
  end

  def scale(p={})
    scale_width  = p[:width]  || width
    scale_height = p[:height] || height
    scale_format = p[:pixel_format] || pixel_format

    # Take the scale context from the caller or allocate our own
    scale_ctx = p[:scale_ctx] || begin
        sws_getContext(width, height, pixel_format,
                       scale_width, scale_height, scale_format,
                       SWS_BICUBIC, nil, nil, nil) or
          raise NoMemoryError, "sws_getContext() failed"
      end

    # Take the output frame from the caller, or allocate a new one
    scale_frame = p[:output_frame] || begin
        self.class.new(:width => scale_width, :height => scale_height,
                       :pixel_format => scale_format, :stream => stream)
      end

    # Scale the image
    rc = sws_scale(scale_ctx, data, linesize, 0, height,
                   scale_frame.data, scale_frame.linesize)

    # Free the scale context if one wasn't provided by the caller
    sws_freeContext(scale_ctx) unless p[:scale_ctx]

    # Let's copy a handful of attributes to the scaled frame
    %w{ pts number best_effort_timestamp key_frame }.each do |k|
      scale_frame.send("#{k}=", send(k))
    end

    # And set the rest by hand
    scale_frame.height = scale_height
    scale_frame.width  = scale_width
    scale_frame.pixel_format = scale_format
    scale_frame
  end
end
