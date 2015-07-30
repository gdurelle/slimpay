module Slimpay
  # Base class defines constants and main variables, requests options, and retrieve the oauth token.
  # It also defines first resources GET methods.
  # Usage:
  #   >> Slimpay::Base.new
  class Base
    def initialize(client_id, client_secret, creditor_reference)
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
    #   Usage:
    #     >> slim = Slimpay::Base.new
    #     >> slim.api_methods
    #     => [apps, creditors, direct_debits, mandates, orders, recurrent_direct_debits, subscribers, ...]
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
