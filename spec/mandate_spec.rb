require 'spec_helper'

describe Slimpay::Mandate do
  it 'calls for OAuth2 connection' do
    expect_any_instance_of(Slimpay::Resource).to receive(:oauth)
    Slimpay::Mandate.new
  end

  it 'generate API methods' do
    allow_any_instance_of(Slimpay::Mandate).to receive(:oauth)
    expect_any_instance_of(Slimpay::Mandate).to receive(:generate_api_methods)
    Slimpay::Mandate.new
  end

  it 'is a Resource child' do
    allow_any_instance_of(Slimpay::Mandate).to receive(:oauth)
    allow_any_instance_of(Slimpay::Mandate).to receive(:generate_api_methods)
    expect(Slimpay::Mandate.new).to be_a Slimpay::Resource
    expect(Slimpay::Mandate.new).to be_an_instance_of Slimpay::Mandate
  end

  it 'has a get_one method' do
    allow_any_instance_of(Slimpay::Mandate).to receive(:oauth)
    allow_any_instance_of(Slimpay::Mandate).to receive(:generate_api_methods)
    expect(Slimpay::Mandate.new).to respond_to :get_one
  end
end
