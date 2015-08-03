require 'spec_helper'

describe Slimpay::Base do
  it 'calls for OAuth2 connection and generate API methods' do
    expect_any_instance_of(Slimpay::Base).to receive(:oauth)
    expect_any_instance_of(Slimpay::Base).to receive(:generate_api_methods)
    Slimpay::Base.new
  end
end
