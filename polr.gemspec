# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'polr/version'

Gem::Specification.new do |spec|
  spec.name          = 'polr'
  spec.version       = Polr::VERSION
  spec.authors       = ['Fabien Dobat']
  spec.email         = ['fabien.dobat@seniormedia.fr']

  spec.summary       = 'Ruby wrapper for Polr API'
  spec.description   = 'A simple ruby wrapper to use your self hosted Polr API'
  spec.homepage      = 'https://github.com/SeniorMedia/polr-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rest-client', '~> 2'

  spec.add_development_dependency 'bundler', '~> 2'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'rake', '~> 10.0'
end
