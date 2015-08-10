module Slimpay
  class Configuration
    attr_accessor :client_id
    attr_accessor :client_secret
    attr_accessor :creditor_reference
    attr_accessor :sandbox
    attr_accessor :return_url
    attr_accessor :notify_url
    attr_accessor :username
    attr_accessor :password

    def initialize
      @client_id = Slimpay::SANDBOX_CLIENT_ID
      @client_secret = Slimpay::SANDBOX_SECRET_ID
      @creditor_reference = Slimpay::SANDBOX_CREDITOR
      @sandbox = true
      @return_url = 'localhost:5000'
      @notify_url = 'localhost:5000'
    end
  end
end
