module Slimpay
  class DirectDebit < Resource
    # Override the Resource#get_one method because the url is not the same for DirectDebits
    #
    def get_one(reference = 1)
      url = "#{@endpoint}/#{@resource_name}/#{reference}"
      response = HTTParty.get(url, headers: options)
      generate_api_methods(JSON.parse(response.body))
      Slimpay.answer(response)
    end

    # Alias method for create_direct_debits
    # ===== Arguments
    #   debit_hash: (Hash) Your payment informations. See API DirectDebit documentation for details.
    #
    #   /!\ Amount as to be rounded to maximum 2 numbers after comma.
    #   If not you'll receive an error : { "code" : 100, "message" : "Internal error : Rounding necessary" }
    def make_payment(debit_hash = default_debit_hash)
      self.create_direct_debits(debit_hash)
    end

    private

    def default_debit_hash
      {
        creditor: {
          reference: @creditor_reference
        },
        mandate: {
          rum: '1'
        },
        amount: 100.00,
        label: 'The label',
        paymentReference: 'Payment 123'
      }
    end
  end
end
