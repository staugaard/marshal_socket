# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'marshal_socket/version'

Gem::Specification.new do |gem|
  gem.name          = 'marshal_socket'
  gem.version       = MarshalSocket::VERSION
  gem.authors       = ['Mick Staugaard']
  gem.email         = ['mick@staugaard.com']
  gem.description   = 'A dead simple way to pass ruby object on a socket'
  gem.summary       = 'A dead simple way to pass ruby object on a socket'
  gem.homepage      = ''

  gem.files         = Dir.glob('{lib,test}/**/*') + ['README.md']
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'minitest'
end
