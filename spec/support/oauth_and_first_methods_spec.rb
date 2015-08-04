RSpec.shared_examples "Expect OAuth and first requests" do |given_class|
  it "Calls OAuth and generates methods" do
    expect_any_instance_of(given_class).to receive(:oauth)
    expect_any_instance_of(given_class).to receive(:request) { { plop: 'lorem' }.to_json }
    expect_any_instance_of(given_class).to receive(:generate_api_methods)
    given_class.new
  end
end
