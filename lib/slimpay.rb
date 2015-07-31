require 'slimpay/version'
require 'oauth2'
require 'httparty'

require 'active_support/core_ext/string/inflections'

require 'slimpay/error'
require 'slimpay/base'
require 'slimpay/resource'
require 'slimpay/app'
require 'slimpay/mandate'
require 'slimpay/order'

# :main: README.md

# Slimpay module defines Simpay's HAPI constants and require dependencies.
module Slimpay
  PRODUCTION_ENDPOINT = 'https://api.slimpay.net'
  API_HEADER = "application/hal+json; profile='https://api.slimpay.net/alps/v1'"

  SANDBOX_ENDPOINT = 'https://api-sandbox.slimpay.net'
  SANDBOX_CLIENT_ID = 'democreditor01'
  SANDBOX_SECRET_ID = 'demosecret01'
  SANDBOX_CREDITOR = 'democreditor'

  # Used to display HTTP requests responses nicely in case of error.
  #
  # ===== Arguments:
  #   http_response: (HTTParty::Response)
  def self.answer(http_response)
    return Slimpay::Error.empty if http_response.nil?
    if http_response.code >= 400
      fail Slimpay::Error.manage_errors(http_response)
    else
      http_response
    end
  end
end

# # TODO: If-None-Match support. (next answer ?= 304)
