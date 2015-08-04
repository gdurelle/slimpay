module Slimpay
  class Configuration
    attr_accessor :client_id
    attr_accessor :client_secret
    attr_accessor :creditor_reference
    attr_accessor :sandbox

    def initialize
      @client_id = Slimpay::SANDBOX_CLIENT_ID
      @client_secret = Slimpay::SANDBOX_SECRET_ID
      @creditor_reference = Slimpay::SANDBOX_CREDITOR
      @sandbox = true
    end
  end
end
