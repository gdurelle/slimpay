module Slimpay
  class Mandate < Resource
      # POST
    def revocate(id = 'mandate01')
      url = "mandates/#{id}/revocation"
      body_options = {}   
	  response = HTTParty.post("#{@endpoint}/#{url}", body: body_options.to_json, headers: options)
      follow_up_api(response)
    end
	
	def document(id = 'mandate01')
      url = "mandates/#{id}/document"
      body_options = {}   
	  response = HTTParty.get("#{@endpoint}/#{url}", body: body_options.to_json, headers: options)
      follow_up_api(response)
    end
	
  end
end
