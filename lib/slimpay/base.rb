module Slimpay
  # Defines constants, main variables, requests options.
  #
  # Connect to the HAPI through OAuth2 and generates HAPI's first resources GET methods.
  # ===== Usage:
  #   slimpay = Slimpay::Base.new(client_id = '1234', client_secret = '987654321', creditor_reference = 'azerty')
  #   slimpay.api_methods
  #   =>
  #     { "post_token"=>"https://api-sandbox.slimpay.net/oauth/token",
  #       "create_orders"=>"https://api-sandbox.slimpay.net/orders",
  #       "get_creditors"=>"https://api-sandbox.slimpay.net/creditors{?reference}",
  #       "get_orders"=>"https://api-sandbox.slimpay.net/orders{?creditorReference,reference}",
  #       "get_mandates"=>"https://api-sandbox.slimpay.net/mandates{?creditorReference,rum}",
  #       "create_documents"=>"https://api-sandbox.slimpay.net/documents",
  #       "get_documents"=>"https://api-sandbox.slimpay.net/documents{?creditorReference,entityReference,reference}",
  #       "create_direct_debits"=>"https://api-sandbox.slimpay.net/direct-debits",
  #       "get_direct_debits"=>"https://api-sandbox.slimpay.net/direct-debits{?id}",
  #       "create_recurrent_direct_debits"=>"https://api-sandbox.slimpay.net/recurrent-direct-debits",
  #       "get_recurrent_direct_debits"=>"https://api-sandbox.slimpay.net/recurrent-direct-debits{?id}",
  #       "get_card_transactions"=>"https://api-sandbox.slimpay.net/card-transactions{?id}",
  #       "get_card_transaction_issues"=>"https://api-sandbox.slimpay.net/card-transaction-issues{?id}",
  #       "profile"=>"https://api-sandbox.slimpay.net/alps/v1"}
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
      oauth
      response = JSON.parse(request)
      generate_api_methods(response)
    end

    # Root endpoint provides GET links to resources.
    # This methods create a method for each one.
    # It will also create new methods from future answers.
    def generate_api_methods(response)
      methods = {}
      response['_links'].each do |k, v|
        next if k.eql?('self')
        name = k.gsub('https://api.slimpay.net/alps#', '').underscore
        next if @methods.present? && @methods.keys.include?(name)
        url = v['href']
        api_args = url.scan(/{\?(.*),?}/).flatten.first
        methods[name] = generate_method(name, url, api_args)
      end
      list_api_methods(methods)
    end

    private

    # An empty request call to the endpoint lists resources.
    def request(url = '')
      response = HTTParty.get("#{@endpoint}/#{url}", headers: options)
      Slimpay.answer response
    end

    # OAuth2 call to retrieve the token
    def oauth
      client = OAuth2::Client.new(@client_id, @client_secret, site: @token_endpoint, headers: options)
      response = client.client_credentials.get_token
      @token = response.token
    end

    def generate_method(name, url, api_args)
      self.class.send(:define_method, name) do |method_arguments = nil|
        if api_args.nil?
          HTTParty.get(url, headers: options)
        else
          clean_url = url.gsub(/{\?.*/, '')
          url_args = format_html_arguments(api_args, method_arguments)
          HTTParty.get("#{clean_url}?#{url_args}", headers: options)
        end
      end
      url
    end

    def format_html_arguments(api_args, method_arguments)
      url_args = ''
      api_args.split(',').each_with_index do |arg, index|
        url_args += "#{arg}=#{method_arguments[arg.to_sym]}"
        url_args += '&' if (index + 1) < api_args.size
      end
      url_args
    end

    # Create the 'api_methods' instance method to retrieve an array of API methods previously created.
    #
    # ===== Usage:
    #   slim = Slimpay::Base.new
    #   slim.api_methods
    #   => [apps, creditors, direct_debits, mandates, orders, recurrent_direct_debits, subscribers, ...]
    def list_api_methods(methods)
      @methods ||= methods
      self.class.send(:define_method, 'api_methods') do
        if @methods != methods
          @methods.merge(methods)
        else
          methods
        end
      end
    end

    def options
      {
        'Accept' => API_HEADER,
        'Authorization' => "Bearer #{@token}",
        'Content-type' => 'application/hal+json',
        'grant_type' => 'client_credentials',
        'scope' => 'api'
      }
    end

    def sandbox?
      @client_id.eql?('democreditor01') ? true : false
    end
  end
end
