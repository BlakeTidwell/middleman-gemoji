# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'middleman-gemoji/version'

Gem::Specification.new do |spec|
  spec.name          = "middleman-gemoji"
  spec.version       = Middleman::Gemoji::VERSION
  spec.authors       = ["Yuya Matsushima"]
  spec.email         = ["terra@e2esound.com"]
  spec.summary       = %q{Github-flavored emoji plugin for Middleman.}
  spec.description   = %q{Github-flavored emoji plugin for Middleman.}
  spec.homepage      = "https://github.com/yterajima/middleman-gemoji"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_runtime_dependency "middleman", ">= 4.0"
  spec.add_runtime_dependency "gemoji", ">= 3.0"

  spec.add_development_dependency "cucumber", ">= 1.3"
  spec.add_development_dependency "capybara", ["~> 2.5.0"]
  spec.add_development_dependency "aruba", "~> 0.7.4"
  spec.add_development_dependency "bundler", ">= 1.5"
  spec.add_development_dependency "rake", ">= 10"
  spec.add_development_dependency "slim", ">= 3.0"
  spec.add_development_dependency "rb-inotify", "~> 0.9"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-minitest", "~> 2.4.6"
end
