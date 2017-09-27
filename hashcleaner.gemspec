# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hashcleaner/version'

Gem::Specification.new do |s|
  s.name          = 'hashcleaner'
  s.version       = HashCleaner::VERSION
  s.date          = '2017-09-27'
  s.summary       = 'A simple hash cleaner'
  s.description   = 'A simple hash cleaner'
  s.authors       = ['Derik Evangelista']
  s.email         = 'kirederik@gmail.com'
  s.files         = Dir.glob('lib/**/*') + ['LICENSE.txt'] + Dir.glob('bin/*')
  s.require_paths = ['lib']
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^spec/})

  s.homepage      = 'http://rubygems.org/gems/hashcleaner'
  s.license       = 'MIT'

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rspec", "~> 3.6"
end
