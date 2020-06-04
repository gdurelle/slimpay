RSpec.shared_examples "Expect OAuth and first requests" do |given_class|
  it "Calls OAuth and generates methods" do
    expect_any_instance_of(Slimpay::Base).to receive(:connect_api_with_oauth)
    expect_any_instance_of(Slimpay::Base).to receive(:request_to_api) {{plop: 'lorem'}.to_json}
    expect_any_instance_of(Slimpay::Base).to receive(:generate_api_methods)
    given_class.new
  end
end
