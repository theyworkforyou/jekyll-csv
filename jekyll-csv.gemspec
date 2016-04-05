# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll/csv/version'

Gem::Specification.new do |spec|
  spec.name          = 'jekyll-csv'
  spec.version       = Jekyll::Csv::VERSION
  spec.authors       = ['Chris Mytton']
  spec.email         = ['chrismytton@gmail.com']

  spec.summary       = 'Load CSVs into Jekyll Collections'
  spec.homepage      = 'https://github.com/theyworkforyou/jekyll-csv'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'jekyll', '>= 3'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'pry'
end
