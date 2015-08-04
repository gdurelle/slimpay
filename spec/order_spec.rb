require 'spec_helper'

describe Slimpay::Order do
  include_examples 'Expect OAuth and first requests', Slimpay::Base

  it 'is a Resource child' do
    allow_any_instance_of(Slimpay::Order).to receive(:oauth)
    allow_any_instance_of(Slimpay::Base).to receive(:request) { { plop: 'lorem' }.to_json }
    allow_any_instance_of(Slimpay::Order).to receive(:generate_api_methods)
    expect(Slimpay::Order.new).to be_a Slimpay::Resource
    expect(Slimpay::Order.new).to be_an_instance_of Slimpay::Order
  end

  it 'has a get_one method' do
    allow_any_instance_of(Slimpay::Order).to receive(:oauth)
    allow_any_instance_of(Slimpay::Base).to receive(:request) { { plop: 'lorem' }.to_json }
    allow_any_instance_of(Slimpay::Order).to receive(:generate_api_methods)
    expect(Slimpay::Order.new).to respond_to :get_one
  end

  it 'has its POST methods shortcuts' do
    allow_any_instance_of(Slimpay::Order).to receive(:oauth)
    allow_any_instance_of(Slimpay::Base).to receive(:request) { { plop: 'lorem' }.to_json }
    allow_any_instance_of(Slimpay::Order).to receive(:generate_api_methods)
    expect(Slimpay::Order.new).to respond_to :login
    expect(Slimpay::Order.new).to respond_to :sign_mandate
  end
end
