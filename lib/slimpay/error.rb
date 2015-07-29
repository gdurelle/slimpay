module Slimpay
  class Error
    def self.empty
      { code: 418, message: "The answer was empty."}
    end

    # code: 906 message: "Error : Could not find acceptable representation"
    # code: 906 message: "Error : Request method 'POST' not supported"
    # code: 904 message: "Access denied : cannot access creditor democreditor"
    # error:"invalid_token", error_description: "Invalid access token: 1234-123456-abcdef-123456"
    # code: 205, message: "Client data are inconsistent : missing query parameters creditorReference and/or rum"
    def self.manage_errors(http_response)
      return display_http_error(http_response) if http_response.code.present?
      http_response
    end

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
      slimerror = JSON.parse(message)
      { code: 400, message: "HTTP Bad Request. Slimpay #{slimerror['code']} : #{slimerror['message']}"}
    end

    def self.forbidden(message)
      slimerror = JSON.parse(message)
      { code: 403, message: "HTTP Forbidden. Slimpay #{slimerror['code']} : #{slimerror['message']}"}
    end

    def self.not_found
      { code: 404, message: "URI not found."}
    end

    def self.not_acceptable(message)
      slimerror = JSON.parse(message)
      { code: 406, message: "HTTP Not Acceptable. Slimpay #{slimerror['code']} : #{slimerror['message']}"}
    end
  end
end
