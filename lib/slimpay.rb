require 'slimpay/version'
require 'oauth2'
require 'httparty'

require 'active_support/core_ext/string/inflections'

require 'slimpay/configuration'
require 'slimpay/error'
require 'slimpay/base'
require 'slimpay/resource'
require 'slimpay/app'
require 'slimpay/mandate'
require 'slimpay/order'
require 'slimpay/direct_debit'

# :main: README.md

# Slimpay module defines Simpay's HAPI constants and require dependencies.
# TODO: If-None-Match support. (next answer ?= 304)
# TODO: wiki/doc full worflow: 1. App to change URls, 2. Order to sign mandate, 3. DirectDebit to pay with mandate.
module Slimpay
  PRODUCTION_ENDPOINT = 'https://api.slimpay.net'
  API_HEADER = "application/hal+json; profile='https://api.slimpay.net/alps/v1'"
  SANDBOX_API_HEADER = "application/hal+json; profile='https://api-sandbox.slimpay.net/alps/v1'"
  SANDBOX_ENDPOINT = 'https://api-sandbox.slimpay.net'
  SANDBOX_CLIENT_ID = 'democreditor01'
  SANDBOX_SECRET_ID = 'demosecret01'
  SANDBOX_CREDITOR = 'democreditor'

  class << self
    attr_accessor :configuration
  end

  # Sets the initial configuration for client_id, client_secret and creditor_reference
  # ===== Usage:
  #   Slimpay.configure do |config|
  #     config.client_id = "your_client_id"
  #     config.client_secret = "your_client_secret"
  #     config.creditor_reference = "your_creditor_reference"
  #     config.sandbox = true
  #     config.notify_url = 'you_notifications_url'
  #     config.return_url = 'your_return_url'
  #   end
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  # Used to display HTTP requests responses nicely in case of error.
  #
  # ===== Arguments:
  #   http_response: (HTTParty::Response)
  def self.answer(http_response)
    return Slimpay::Error.empty if http_response.nil?
    if http_response.code >= 400
      Slimpay::Error.new(http_response)
    else
      http_response
    end
  end
end
