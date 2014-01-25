# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'libav/version'

Gem::Specification.new do |spec|
  spec.name          = "ffi-libav"
  spec.version       = Libav::VERSION
  spec.authors       = ["David M. Lary"]
  spec.email         = ["dmlary@gmail.com"]
  spec.summary       = %q{Ruby FFI bindings and wrapper for Libav}
  spec.homepage      = "https://github.com/dmlary/ffi-libav"
  spec.license       = "BSD 3-Clause"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_dependency "ffi"
end
