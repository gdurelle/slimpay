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
    def initialize
      init_config
      connect_api_with_oauth
      api_response = JSON.parse(request_to_api)
      generate_api_methods(api_response)
    end

    # Root endpoint provides GET links to resources.
    # This methods create a method for each resources.
    # It will also create new methods from future answers.
    def generate_api_methods(response)
      methods = {}
      links = response['_links']
      links = links.merge(response['_embedded']['items'].first['_links']) if response['_embedded'] && response['_embedded']['items']
      links.each do |k, v|
        name = k.gsub('https://api.slimpay.net/alps#', '').underscore
        next if @methods && @methods.keys.include?(name) && !k.eql?('self')
        url = v['href']
        api_args = url.scan(/{\?(.*),?}/).flatten.first
        methods[name] = generate_method(name, url, api_args)
      end
      list_api_methods(methods)
    end

    private

    def init_config
      Slimpay.configuration ||= Configuration.new
      @client_id = Slimpay.configuration.client_id
      @client_secret = Slimpay.configuration.client_secret
      @creditor_reference = Slimpay.configuration.creditor_reference
      @sandbox = Slimpay.configuration.sandbox
      @return_url = Slimpay.configuration.return_url
      @notify_url = Slimpay.configuration.notify_url
      @endpoint = sandbox? ? SANDBOX_ENDPOINT : PRODUCTION_ENDPOINT
      @token_endpoint = @endpoint + '/oauth/token'
    end

    # A request call to the endpoint.
    # An empty call will return list of available methods in the API.
    def request_to_api(url = '')
      response = HTTParty.get("#{@endpoint}/#{url}", headers: options)
      Slimpay.answer response
    end

    # OAuth2 call to retrieve the token
    def connect_api_with_oauth
      client = OAuth2::Client.new(@client_id, @client_secret, site: @token_endpoint, headers: options)
      response = client.client_credentials.get_token
      @token = response.token
    end

    # === Arguments:
    #   name: (String) The method name
    #   url: (String) URL called in the method block
    #   api_args: (String) API arguments for this URL.
    def generate_method(name, url, api_args)
      if name.start_with?('create', 'post')
        generate_post_method(name, url)
      elsif name.start_with?('patch')
        generate_patch_method(name, url)
      else
        generate_get_method(name, url, api_args)
      end
      url
    end

    def generate_get_method(name, url, api_args)
      self.class.send(:define_method, name) do |method_arguments = nil|
        if api_args.nil?
          response = HTTParty.get(url, headers: options)
          follow_up_api(response)
        else
          clean_url = url.gsub(/{\?.*/, '')
          url_args = format_html_arguments(api_args, method_arguments)
          response = HTTParty.get("#{clean_url}?#{url_args}", headers: options)
          follow_up_api(response)
        end
      end
    end

    def generate_post_method(name, url)
      self.class.send(:define_method, name) do |method_arguments = nil|
        response = HTTParty.post(url, body: method_arguments.to_json, headers: options)
        follow_up_api(response)
      end
    end

    def generate_patch_method(name, url)
      self.class.send(:define_method, name) do |method_arguments = nil|
        response = HTTParty.patch(url, body: method_arguments.to_json, headers: options)
        follow_up_api(response)
      end
    end

    # Change APIs documented URL's arguments into real HTTP arguments through given method arguments
    # ===== Arguments
    #   api_args: (String) Slimpay given argument within URLs. Formated like: ?{arg1, arg2}
    #   method_arguments: (String) Arguments called on the currently defined method.
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
        @methods = @methods.merge(methods) if @methods != methods
        @methods
      end
    end

    # Catch up potential errors and generate new methods if needed.
    def follow_up_api(response)
      answer = Slimpay.answer(response)
      generate_api_methods(JSON.parse(response))
      answer
    end

    def options
      {
        'Accept' => API_HEADER,
        'Authorization' => "Bearer #{@token}",
        'Content-type' => 'application/hal+json',
        'grant_type' => 'client_credentials',
        'scope' => 'api_admin'
      }
    end

    def sandbox?
      @sandbox || @client_id.eql?('democreditor01') ? true : false
    end
  end
end
