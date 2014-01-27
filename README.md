# FFI::Libav

Ruby FFI bindings and wrappers for Libav libraries, version 0.8.6.

## Installation

Add this line to your application's Gemfile:

    gem 'ffi-libav'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ffi-libav

## Usage

```ruby
require 'ffi-ffmpeg'

# Allocate a reader for our video file
reader = FFmpeg::Reader.new(ARGV[0])

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

## Contributing

1. Fork it ( http://github.com/<my-github-username>/ffi-libav/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

