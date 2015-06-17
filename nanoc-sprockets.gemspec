# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nanoc/sprockets/version'

Gem::Specification.new do |spec|
  spec.name          = 'nanoc-sprockets3'
  spec.version       = Nanoc::Sprockets::VERSION
  spec.homepage      = 'https://github.com/barraq/nanoc-sprockets'
  spec.summary       = %q{Sprockets 3.x support for nanoc.}
  spec.description   = %q{Provides Sprockets 3.x helper and filter for nanoc.}

  spec.authors       = ["Remi Barraquand"]
  spec.email         = ["dev@remibarraquand.com"]
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 1.9.3'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.rdoc_options     = [ '--main', 'README.md' ]
  spec.extra_rdoc_files = [ 'LICENSE', 'README.md' ]

  spec.add_runtime_dependency 'sprockets', '~> 3.2', '>= 3.0.0'

  spec.add_development_dependency 'bundler', '~> 1.5'
end
