module Slimpay
  class Resource < Base

    # Shortcut to get a resource without providing hash of parameters but just the resource's reference.
    #
    # Example:
    #   >> mandates = Slimpay::Mandate.new
    #   >> mandates.get_one
    # Arguments:
    #   reference: (String)
    def get_one(reference = 1)
      response = HTTParty.get("#{@endpoint}/creditors/#{@creditor_reference}/#{self.class.to_s.demodulize.downcase.pluralize}/#{reference}", headers: options)
      Slimpay.answer(response)
    end

    private

    # Example:
    #   >> order = Slimpay::Order.new
    #   >> order.get_orders({creditorReference: @creditor_reference, reference: 1})
    def generate_api_methods
      response = request(self.class.to_s.demodulize.downcase.pluralize)
      res = JSON.parse(response)
      res['descriptor'].each do |api_hash|
        next unless is_api_method?(api_hash['id'])
        self.class.send(:define_method, api_hash['id'].underscore) do |arguments|
          method_name = api_hash['id'].scan(/\w+/)
          case method_name.first
          when 'get'
            # {creditorReference: @creditor_reference, reference: 1}
            # $stdout.puts "---------------#{method_name.last} calling #{@endpoint}/#{method_name.last}?#{http_args(arguments)}"
            response = HTTParty.get("#{@endpoint}/#{method_name.last}?#{http_args(arguments)}", headers: options)
            Slimpay.answer(response)
          when 'create', 'post'
            HTTParty.post("#{@endpoint}/#{method_name.last}", body: arguments, headers: options)
          end
        end
      end
      list_api_methods(res)
    end

    # Change a hash of arguments into URI arguments
    def http_args(args)
      http_args = ""
      index = 0
      args.each do |k, v|
        http_args += "#{k}=#{v}"
        http_args += "&" if (index + 1) < args.size
        index += 1
      end
      http_args
    end

    # Override Base class method because resources do not have 'href' attributes, only ids.
    def list_api_methods(endpoint_results)
      self.class.send(:define_method, 'api_methods') do
        return endpoint_results['descriptor'].map{ |api_hash| api_hash['id'].underscore if is_api_method?(api_hash['id']) }.compact
      end
    end

    # Some resources are purely descriptive, typed as 'semantic' in the API.
    # We only want the usefull methods here.
    def is_api_method?(name)
      name.start_with?('get', 'patch', 'post', 'create')
    end
  end
end
