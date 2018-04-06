lib = expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'slimpay/version'

Gem::Specification.new do |spec|
  spec.name          = 'slimpay'
  spec.version       = Slimpay::VERSION
  spec.authors       = ['Gregory Durelle']
  spec.email         = ['gregory.durelle@gmail.com']

  spec.summary       = %(Slimpay HAPI for Ruby.)
  spec.description   = %(Ruby library for Slimpay's Hypermedia API.)
  spec.homepage      = "https://github.com/gdurelle/slimpay"
  spec.license       = 'MIT'

  spec.post_install_message = %(Please refer to Slimpay's API https://api-sandbox.slimpay.net/docs for more informations.)

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   fail 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 5.1', '>= 5.1.1'
  spec.add_dependency 'httparty', '~> 0.16'
  spec.add_dependency 'oauth2', '~> 1.4'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.7'
  spec.add_development_dependency 'rubocop', '~> 0.54'
  spec.add_development_dependency 'vcr', '~> 4.0'
  spec.add_development_dependency 'webmock', '~> 3.0'
end
