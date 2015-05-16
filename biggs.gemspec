# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'biggs/version'

Gem::Specification.new do |s|
  s.name        = 'eropple-biggs'
  s.version     = Biggs::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Sebastian Munz', 'Ed Ropple']
  s.email       = ['sebastian@yo.lk', 'ed+biggs@edropple.com']
  s.homepage    = 'https://github.com/eropple/biggs'
  s.summary     = 'biggs is a small ruby gem/rails plugin for formatting postal addresses from over 60 countries.'
  s.description = 'biggs is a small ruby gem/rails plugin for formatting postal addresses from over 60 countries. This version is maintained by Ed Ropple off of the abandoned source.'

  s.rubyforge_project = 'biggs'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'activerecord',            '>= 3.0'
  s.add_dependency 'countries',            '>= 0.11.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec',       '>= 3.0.0'
  s.add_development_dependency 'rspec-its',       '>= 1.1.0'
  s.add_development_dependency 'sqlite3',     '>= 1.3.5'
  s.add_development_dependency 'pry'
end
