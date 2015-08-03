module Slimpay
  # An abstract resource to be inherited from.
  #
  # Defines HAPI resource non-semantic methods.
  class Resource < Base
    def initialize(client_id = nil, client_secret = nil, creditor_reference = nil)
      @resource_name = self.class.to_s.demodulize.downcase.pluralize
      super(client_id, client_secret, creditor_reference)
    end

    # Shortcut method to get a resource with only resource's reference.
    #
    # The above example shall return the same result as
    #   mandates = Slimpay::Mandate.new
    #   mandates.get_mandates({creditorReference: @creditor_reference, reference: 1})
    #
    # ===== Example:
    #   mandates = Slimpay::Mandate.new
    #   mandates.get_one(1)
    # ===== Arguments:
    #   reference: (String)
    def get_one(reference = 1)
      url = "#{@endpoint}/creditors/#{@creditor_reference}/#{@resource_name}/#{reference}"
      response = HTTParty.get(url, headers: options)
      Slimpay.answer(response)
    end
  end
end
