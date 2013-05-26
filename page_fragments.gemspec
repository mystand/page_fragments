# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'page_fragments/version'

Gem::Specification.new do |gem|
  gem.name          = "page_fragments"
  gem.version       = PageFragments::VERSION
  gem.authors       = ["Alexandr Promakh"]
  gem.email         = ["s-promakh@ya.ru"]
  gem.description   = %q{ Storage page fragments in database }
  gem.summary       = gem.description
  gem.homepage      = "http://mystand.ru/"

  gem.files         = `git ls-files`.split($/)
  gem.require_paths = ["lib"]

  gem.required_ruby_version = ">= 1.9.2"

  gem.license       = "MIT"

  gem.add_dependency "haml", "~> 4.0.3"
end
