module Slimpay
  # An abstract CardAlias to be inherited from.
  #
  # Defines HAPI CardAlias non-semantic methods.
  class RecurrentCardTransaction < Resource
    def initialize
      @resource_name = self.class.to_s.demodulize.underscore.dasherize.pluralize
      super
    end

    def get_one(id = 1)
      url = "#{@endpoint}/recurrent_card_transaction/#{id}"
      response = HTTParty.get(url, headers: options)
      generate_api_methods(JSON.parse(response.body))
      Slimpay.answer(response)
    end

	def cancel(id = 'card-transac-1')
      url = "recurrent-card-transactions/#{id}/cancellation"
      body_options = {}   
	  response = HTTParty.post("#{@endpoint}/#{url}", body: body_options.to_json, headers: options)
      follow_up_api(response)
    end
  end
end
