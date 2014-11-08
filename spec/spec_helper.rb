require 'rspec/its'
require 'ffi-libav'
require 'yaml'
require 'timeout'
require 'zlib'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
