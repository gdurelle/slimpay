module Slimpay
  # An abstract CardAlias to be inherited from.
  #
  # Defines HAPI CardAlias non-semantic methods.
  class CardAlias < Resource
    def initialize
      @resource_name = self.class.to_s.demodulize.underscore.dasherize.pluralize
      super
    end

    def get_one(id = 1)
      url = "#{@endpoint}/card_aliases/#{id}"
      response = HTTParty.get(url, headers: options)
      generate_api_methods(JSON.parse(response.body))
      Slimpay.answer(response)
    end
  end
end
