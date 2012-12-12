# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'caterer/version'

Gem::Specification.new do |gem|
  gem.name          = "caterer"
  gem.version       = Caterer::VERSION
  gem.authors       = ["Tyler Flint"]
  gem.email         = ["tylerflint@gmail.com"]
  gem.description   = %q{Caterer is a server configuration tool that caters to your servers with a push model, with support for chef recipes}
  gem.summary       = %q{A server configuration tool that caters to your servers with a push model, with support for chef recipes}
  gem.homepage      = ""

  gem.add_dependency 'log4r'
  gem.add_dependency 'activesupport'
  gem.add_dependency 'vli'
  gem.add_dependency 'net-ssh'
  gem.add_dependency 'net-scp'
  gem.add_dependency 'tilt'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
