module Slimpay
  # An abstract Payment to be inherited from.
  #
  # Defines HAPI Payment non-semantic methods.
  class Payment < Resource
    def initialize
      @resource_name = self.class.to_s.demodulize.underscore.dasherize.pluralize
      super
    end

    def get_one(id = 1)
      url = "#{@endpoint}/payments/#{id}"
      response = HTTParty.get(url, headers: options)
      generate_api_methods(JSON.parse(response.body))
      Slimpay.answer(response)
    end
	
	def issues(id = 1)
      url = "#{@endpoint}/payments/#{id}/issues"
      response = HTTParty.get(url, headers: options)
      generate_api_methods(JSON.parse(response.body))
      Slimpay.answer(response)
    end

	def refund(id, amount)
      url = "payments/#{id}/refund"
      body_options = {amount: amount}   
	  response = HTTParty.post("#{@endpoint}/#{url}", body: body_options.to_json, headers: options)
      follow_up_api(response)
    end
	
	def cancel(id)
      url = "payments/#{id}/cancellation"
      body_options = {}   
	  response = HTTParty.post("#{@endpoint}/#{url}", body: body_options.to_json, headers: options)
      follow_up_api(response)
    end

  end
end
