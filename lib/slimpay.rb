require "slimpay/version"
require 'oauth2'
require 'httparty'

require 'active_support/core_ext/string/inflections'

require 'slimpay/error'
require 'slimpay/base'
require 'slimpay/resource'
require 'slimpay/app'
require 'slimpay/mandate'
require 'slimpay/order'

# SlimPay
# TODO: If-None-Match support. (next answer ?= 304)
# API Docs: https://api-sandbox.slimpay.net/docs/

# SANDBOX CREDENTIALS
# @client_id =  'democreditor01'
# @client_secret = 'demosecret01'
# Base64: ZGVtb2NyZWRpdG9yMDE6ZGVtb3NlY3JldDAx    ||   eb831ef7-c8ee-42d3-b3aa-a2e49f859bc1
# creditor_reference : democreditor
# creditors/democreditor/apps/democreditor01
module Slimpay
  PRODUCTION_ENDPOINT = 'https://api.slimpay.net'
  SANDBOX_ENDPOINT = 'https://api-sandbox.slimpay.net'
  API_HEADER = "application/hal+json; profile='https://api.slimpay.net/alps/v1'"

  def self.answer(http_response)
    return Slimpay::Error.empty if http_response.nil?
    if http_response.code >= 400
      Slimpay::Error.manage_errors(http_response)
    else
      http_response
    end
  end
end
