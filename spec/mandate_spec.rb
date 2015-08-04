require 'spec_helper'

describe Slimpay::Mandate do
  include_examples 'Expect OAuth and first requests', Slimpay::Base

  it 'is a Resource child' do
    allow_any_instance_of(Slimpay::Mandate).to receive(:oauth)
    allow_any_instance_of(Slimpay::Base).to receive(:request) { { plop: 'lorem' }.to_json }
    allow_any_instance_of(Slimpay::Mandate).to receive(:generate_api_methods)
    expect(Slimpay::Mandate.new).to be_a Slimpay::Resource
    expect(Slimpay::Mandate.new).to be_an_instance_of Slimpay::Mandate
  end

  it 'has a get_one method' do
    allow_any_instance_of(Slimpay::Mandate).to receive(:oauth)
    allow_any_instance_of(Slimpay::Base).to receive(:request) { { plop: 'lorem' }.to_json }
    allow_any_instance_of(Slimpay::Mandate).to receive(:generate_api_methods)
    expect(Slimpay::Mandate.new).to respond_to :get_one
  end
end
