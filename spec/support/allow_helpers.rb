def allow_oauth_and_first_requests(given_class)
  allow_any_instance_of(given_class).to receive(:connect_api_with_oauth)
  allow_any_instance_of(Slimpay::Base).to receive(:request_to_api) {{plop: 'lorem'}.to_json}
  allow_any_instance_of(given_class).to receive(:generate_api_methods)
end
