module Slimpay
  # Inherits from Resouce and thus defines its associated resource's methods.
  #
  # Defines shortcut methods for the create_order method with various arguments.
  class Order < Resource
    # Override the Resource#get_one method because the url is not the same for Orders
    #
    # ===== Example:
    #   orders = Slimpay::Order.new
    #   orders.get_one
    #   =>
    #     {"_links"=>
    #       {"self"=>{"href"=>"https://api-sandbox.slimpay.net/creditors/democreditor/orders/1"},
    #        "https://api.slimpay.net/alps#get-creditor"=>{"href"=>"https://api-sandbox.slimpay.net/creditors/democreditor"},
    #        "https://api.slimpay.net/alps#get-subscriber" =>
    #           {"href"=>"https://api-sandbox.slimpay.net/creditors/democreditor/orders/1/subscribers/subscriber01"},
    #        "https://api.slimpay.net/alps#user-approval" =>
    #           {"href"=>"https://slimpay.net/slimpaytpe16/userApproval?accessCode=spK534N0cuZztBGwj2FjC6eKzcsKFRzXbfy8buloUHiZV6p9PhIfcPgV7c507R"},
    #        "https://api.slimpay.net/alps#get-order-items"=>{"href"=>"https://api-sandbox.slimpay.net/creditors/democreditor/orders/1/items"},
    #        "https://api.slimpay.net/alps#get-mandate"=>{"href"=>"https://api-sandbox.slimpay.net/creditors/democreditor/mandates/1"}},
    #      "reference"=>"1",
    #      "state"=>"closed.completed",
    #      "started"=>true,
    #      "dateCreated"=>"2014-12-12T09:35:39.000+0000",
    #      "mandateReused"=>false}
    # ===== Arguments:
    #   reference: (String)
    def get_one(reference = 1)
      query_options = "creditorReference=#{@creditor_reference}&reference=#{reference}"
      response = HTTParty.get("#{@endpoint}/#{@resource_name}?#{query_options}", headers: options)
      follow_up_api(response)
    end

    # POST
    def login(reference = 'subscriber01')
      url = 'orders'
      body_options = {
        creditor: {
          reference: @creditor_reference
        },
        subscriber: {
          reference: reference
        },
        items: [{
          type: 'subscriberLogin'
        }],
        started: true
      }
      response = HTTParty.post("#{@endpoint}/#{url}", body: body_options.to_json, headers: options)
      follow_up_api(response)
    end

    # POST
    # This will send a create_order request with
    # ===== Arguments
    #   reference: (String) The reference to your User in your application. Use a unique key.
    #   Slimpay will refer to it for future answers.
    # ===== Returns
    #   The url to the SEPA mandate approval page.
    def sign_mandate(reference = 'subscriber01', signatory = default_signatory)
      url = 'orders'
      sepa = { bic: bic, iban: iban }
      # TODO: set user infos by hand.
      body_options = {
        creditor: {
          reference: @creditor_reference
        },
        subscriber: {
          reference: reference
        },
        items: [{
          type: 'signMandate',
          mandate: {
            standard: 'SEPA',
            signatory: signatory
          }
        }],
        started: true
      }
      response = HTTParty.post("#{@endpoint}/#{url}", body: body_options.to_json, headers: options)
      JSON.parse(follow_up_api(response))
    end

    private

    def default_signatory
      {
        honorificPrefix: 'Mr',
        familyName: 'Doe',
        givenName: 'John',
        telephone: '+33612345678',
        email: 'john.doe@gmail.com',
        billingAddress: {
          street1: '27 rue des fleurs',
          street2: 'Bat 2',
          postalCode: '75008',
          city: 'Paris',
          country: 'FR'
        }
      }
    end
  end
end
