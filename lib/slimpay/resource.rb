module Slimpay
  # Resource class defines an abstract resource to be inherited from.
  # Defines resource's non-semantic methods.
  class Resource < Base
    # Shortcut methods to get a resource with only resource's reference.
    #
    # The above example shall return the same result as get_mandates({creditorReference: @creditor_reference, reference: 1})
    #
    # Example:
    #   >> mandates = Slimpay::Mandate.new
    #   >> mandates.get_one
    # Arguments:
    #   reference: (String)
    def get_one(reference = 1)
      resource_name = @resource_name
      url = "#{@endpoint}/creditors/#{@creditor_reference}/#{resource_name}/#{reference}"
      response = HTTParty.get(url, headers: options)
      Slimpay.answer(response)
    end

    private

    # Retrieve and define get/post methods for each non-semantic methods.
    # Example:
    #   >> order = Slimpay::Order.new
    #   >> order.get_orders({creditorReference: @creditor_reference, reference: 1})
    def generate_api_methods
      response = request(@resource_name)
      res = JSON.parse(response)
      res['descriptor'].each do |api_hash|
        next unless api_method?(api_hash['id'])
        define_api_method(api_hash)
      end
      list_api_methods(res)
    end

    # Define a specific method from the API
    # Arguments:
    #   api_hash: (Hash)
    def define_api_method(api_hash)
      self.class.send(:define_method, api_hash['id'].underscore) do |arguments|
        verb_and_name = api_hash['id'].scan(/\w+/)
        case verb_and_name.first
        when 'get'
          response = HTTParty.get("#{@endpoint}/#{verb_and_name.last}?#{http_args(arguments)}", headers: options)
          Slimpay.answer(response)
        when 'create', 'post'
          HTTParty.post("#{@endpoint}/#{verb_and_name.last}", body: arguments, headers: options)
        end
      end
    end

    # Change a hash of arguments into URI arguments
    def http_args(args)
      http_args = ''
      index = 0
      args.each do |k, v|
        http_args += "#{k}=#{v}"
        http_args += '&' if (index + 1) < args.size
        index += 1
      end
      http_args
    end

    # Override Base class method because resources do not have 'href' attributes, only ids.
    def list_api_methods(endpoint_results)
      self.class.send(:define_method, 'api_methods') do
        return endpoint_results['descriptor'].map { |api_hash| api_hash['id'].underscore if api_method?(api_hash['id']) }.compact
      end
    end

    # Some resources are purely descriptive, typed as 'semantic' in the API.
    # We only want the usefull methods here.
    def api_method?(name)
      name.start_with?('get', 'patch', 'post', 'create')
    end
  end
end
