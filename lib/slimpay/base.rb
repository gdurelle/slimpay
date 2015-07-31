module Slimpay
  # Defines constants, main variables, requests options.
  #
  # Connect to the HAPI through OAuth2 and generates HAPI's first resources GET methods.
  # ===== Usage:
  #   >> slimpay = Slimpay::Base.new(client_id = '1234', client_secret = '987654321', creditor_reference = 'azerty')
  #   >> slimpay.api_methods
  #   =>
  #     {"apps"=>"https://api-sandbox.slimpay.net/alps/v1/apps"}
  #     {"bank_accounts"=>"https://api-sandbox.slimpay.net/alps/v1/bank-accounts"}
  #     {"billing_addresses"=>"https://api-sandbox.slimpay.net/alps/v1/billing-addresses"}
  #     {"binary_contents"=>"https://api-sandbox.slimpay.net/alps/v1/binary-contents"}
  #     {"card_transactions"=>"https://api-sandbox.slimpay.net/alps/v1/card-transactions"}
  #     {"card_transaction_issues"=>"https://api-sandbox.slimpay.net/alps/v1/card-transaction-issues"}
  #     {"creditors"=>"https://api-sandbox.slimpay.net/alps/v1/creditors"}
  #     {"direct_debits"=>"https://api-sandbox.slimpay.net/alps/v1/direct-debits"}
  #     {"direct_debit_issues"=>"https://api-sandbox.slimpay.net/alps/v1/direct-debit-issues"}
  #     {"documents"=>"https://api-sandbox.slimpay.net/alps/v1/documents"}
  #     {"errors"=>"https://api-sandbox.slimpay.net/alps/v1/errors"}
  #     {"mandates"=>"https://api-sandbox.slimpay.net/alps/v1/mandates"}
  #     {"orders"=>"https://api-sandbox.slimpay.net/alps/v1/orders"}
  #     {"order_items"=>"https://api-sandbox.slimpay.net/alps/v1/order-items"}
  #     {"postal_addresses"=>"https://api-sandbox.slimpay.net/alps/v1/postal-addresses"}
  #     {"recurrent_direct_debits"=>"https://api-sandbox.slimpay.net/alps/v1/recurrent-direct-debits"}
  #     {"signatories"=>"https://api-sandbox.slimpay.net/alps/v1/signatories"}
  #     {"subscribers"=>"https://api-sandbox.slimpay.net/alps/v1/subscribers"}
  #     {"user_approvals"=>"https://api-sandbox.slimpay.net/alps/v1/user-approvals"}
  #
  # ===== Arguments
  #   client_id: (String)
  #   client_secret: (String)
  #   creditor_reference: (String)
  class Base
    def initialize(client_id = nil, client_secret = nil, creditor_reference = nil)
      @client_id = client_id || SANDBOX_CLIENT_ID
      @client_secret = client_secret || SANDBOX_SECRET_ID
      @creditor_reference = creditor_reference || SANDBOX_CREDITOR
      @endpoint = sandbox? ? SANDBOX_ENDPOINT : PRODUCTION_ENDPOINT
      @token_endpoint = @endpoint + '/oauth/token'
      @api_suffix = '/alps/v1/'
      @resource_name = self.class.to_s.demodulize.downcase.pluralize
      oauth
      generate_api_methods
    end

    private

    # An empty request call to the endpoint lists resources.
    def request(url = '')
      response = HTTParty.get("#{@endpoint}#{@api_suffix}#{url}")
      Slimpay.answer response
    end

    # OAuth2 call to retrieve the token
    def oauth
      client = OAuth2::Client.new(@client_id, @client_secret, site: @token_endpoint, headers: options)
      response = client.client_credentials.get_token
      @token = response.token
    end

    # Root endpoint provides GET links to resources.
    # This methods create a method for each one.
    def generate_api_methods
      response = request
      res = JSON.parse(response)
      res['descriptor'].each do |api_hash|
        url = api_hash['href']
        self.class.send(:define_method, api_hash['name'].underscore) do
          HTTParty.get(url, headers: options)
        end
      end
      list_api_methods(res)
    end

    # Create the 'api_methods' instance method to retrieve an array of API methods previously created.
    #
    # ===== Usage:
    #   >> slim = Slimpay::Base.new
    #   >> slim.api_methods
    #   => [apps, creditors, direct_debits, mandates, orders, recurrent_direct_debits, subscribers, ...]
    def list_api_methods(endpoint_results)
      self.class.send(:define_method, 'api_methods') do
        return endpoint_results['descriptor'].map { |api_hash| { api_hash['name'].underscore => api_hash['href'] } }
      end
    end

    def options
      {
        'Accept' => API_HEADER,
        'Authorization' => "Bearer #{ @token }",
        'grant_type' => 'client_credentials',
        'scope' => 'api'
      }
    end

    def sandbox?
      @client_id.eql?('democreditor01') ? true : false
    end
  end
end
