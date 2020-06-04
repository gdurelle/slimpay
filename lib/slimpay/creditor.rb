module Slimpay
  # An abstract Creditor to be inherited from.
  #
  # Defines HAPI Creditor non-semantic methods.
  class Creditor < Resource
    def initialize
      @resource_name = self.class.to_s.demodulize.underscore.dasherize.pluralize
      super
    end

    def get_one(reference = 1)
      url = "#{@endpoint}/creditors/#{reference}"
      response = HTTParty.get(url, headers: options)
      generate_api_methods(JSON.parse(response.body))
      Slimpay.answer(response)
    end
  end
end
