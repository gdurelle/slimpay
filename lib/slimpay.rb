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

# SlimPay Hypermedia API
# API Docs: https://api-sandbox.slimpay.net/docs/
#
# SANDBOX CREDENTIALS
# @client_id =  'democreditor01'
# @client_secret = 'demosecret01'
# creditor_reference : democreditor
module Slimpay
  PRODUCTION_ENDPOINT = 'https://api.slimpay.net'
  API_HEADER = "application/hal+json; profile='https://api.slimpay.net/alps/v1'"

  SANDBOX_ENDPOINT = 'https://api-sandbox.slimpay.net'
  SANDBOX_CLIENT_ID = 'democreditor01'
  SANDBOX_SECRET_ID = 'demosecret01'
  SANDBOX_CREDITOR = 'democreditor'

  def self.answer(http_response)
    return Slimpay::Error.empty if http_response.nil?
    if http_response.code >= 400
      Slimpay::Error.manage_errors(http_response)
    else
      http_response
    end
  end
end

# # TODO: If-None-Match support. (next answer ?= 304)
