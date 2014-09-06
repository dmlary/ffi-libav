require 'forwardable'
require 'ffi/libav'
require 'libav/version'
require 'libav/frame'
require 'libav/stream'
require 'libav/reader'

module Libav

  private

  @@registered_all = false
  def self.register_all
    return if @@registered_all
    FFI::Libav.av_register_all
    @@registered_all = true
  end

  def self.log_level=(v)
    FFI::Libav.av_log_set_level v
  end

  def self.log_level
    FFI::Libav.av_log_get_level
  end
end

class String
  def hexdump
    buf = ""
    offset = 0
    words = self.unpack("N%d" % (self.length/4.0).ceil)
    until words.empty?
      line = words.shift(4).compact
      buf += sprintf("[%04x] " + ("%08x " * line.size) + "|%s|\n", 
                     offset * 16, *line, 
                     line.pack("N%d" % line.size).tr("^\040-\176","."))
      offset += 1
    end
    buf
  end unless String.instance_methods.include? :hexdump
end

class FFI::Struct
  def to_hash
    return {} if pointer.null?

    members.inject({}) { |h,k| h[k] = send(:[], k); h }
  end unless FFI::Struct.instance_methods.include? :to_hash

  def to_hexdump
    self.pointer.read_bytes(self.size).hexdump
  end
end


