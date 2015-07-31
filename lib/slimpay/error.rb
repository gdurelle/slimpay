module Slimpay
  # To display Slimpay error messages with the HTTP code.
  #
  # ==== Possible HAPI errors
  # * code: 906 message: "Error : Could not find acceptable representation"
  # * code: 906 message: "Error : Request method 'POST' not supported"
  # * code: 904 message: "Access denied : cannot access creditor democreditor"
  # * error:"invalid_token", error_description: "Invalid access token: 1234-123456-abcdef-123456"
  # * code: 205, message: "Client data are inconsistent : missing query parameters creditorReference and/or rum"
  class Error
    # If the HTTP response is nil or empty returns an actual message.
    def self.empty
      { code: 418, message: 'The answer was empty.' }
    end

    # Returns either formated error with its HTTP code or the raw HTTP response.
    def self.manage_errors(http_response)
      return display_http_error(http_response) if defined?(http_response.code)
      http_response
    end

    private

    def display_http_error(http_response)
      case http_response.code
      when 400
        return Slimpay::Error.bad_request(http_response)
      when 403
        return Slimpay::Error.forbidden(http_response)
      when 404
        return Slimpay::Error.not_found
      when 406
        return Slimpay::Error.not_acceptable(http_response)
      else
        return http_response
      end
    end

    def self.bad_request(message)
      { code: 400, message: "HTTP Bad Request. #{ slimpay_error(message) }" }
    end

    def self.forbidden(message)
      { code: 403, message: "HTTP Forbidden. #{ slimpay_error(message) }" }
    end

    def self.not_found
      { code: 404, message: 'URI not found.' }
    end

    def self.not_acceptable(message)
      { code: 406, message: "HTTP Not Acceptable. #{ slimpay_error(message) }" }
    end

    def slimpay_error(http_message)
      slimpay_error = JSON.parse(http_message)
      slimpay_code = slimpay_error['code']
      slimpay_message = slimpay_error['message']
      "Slimpay #{ slimpay_code } : #{ slimpay_message }"
    end
  end
end
