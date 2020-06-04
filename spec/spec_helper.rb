$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'slimpay'
Dir["./spec/support/**/*.rb"].sort.each {|f| require f}
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/support/cassettes'
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = false
  config.ignore_localhost = true
  config.configure_rspec_metadata!
end
