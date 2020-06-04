module Slimpay
  # Used only to get and set callback URLs.
  class App < Resource
    # Prepare an admin token for app requests.
    #
    # Arguments:
    #   username: Your Slimpay admin username
    #   password: Your Slimpay admin password
    def initialize(username = nil, password = nil)
      init_config
      @username = username || Slimpay.configuration.username
      @password = password || Slimpay.configuration.password
      @basic_auth = {username: "#{@creditor_reference}##{@username}", password: @password}
      response = HTTParty.post(@token_endpoint, basic_auth: @basic_auth, body: app_options)
      @token = response['access_token']
    end

    # Change the returnUrl
    # ===== Example:
    #   app = Slimpay::App.new
    #   app.return_url = "mywebsite.com/client/123/"
    def return_url(url)
      response = HTTParty.patch("#{@endpoint}/creditors/#{@creditor_reference}/apps/#{@client_id}", body: {returnUrl: url}.to_json, headers: options)
      Slimpay.answer(response)
    end

    # Change the notifyUrl
    def notify_url(url)
      response = HTTParty.patch("#{@endpoint}/creditors/#{@creditor_reference}/apps/#{@client_id}", body: {notifyUrl: url}.to_json, headers: options)
      Slimpay.answer(response)
    end

    # Change the notification and return URLs.
    #
    # ===== Arguments:
    #   returnUrl: (String) URL to your app the customer is gonna be redirected to when leaving Slimpay platform.
    #   notifyUrl: (String) URL to your app Slimpay is gonna send a notification to, to confirm a Signature, a payment, etc.
    def change_urls(urls_params)
      response = HTTParty.patch("#{@endpoint}/creditors/#{@creditor_reference}/apps/#{@client_id}", body: urls_params.to_json, headers: options)
      Slimpay.answer(response)
    end

    private

    def app_options
      {
        'Accept' => API_HEADER,
        'Content-type' => 'application/hal+json',
        'grant_type' => 'client_credentials',
        'scope' => 'api_admin'
      }
    end
  end
end
