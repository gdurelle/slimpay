require 'spec_helper'

describe Slimpay::Order do
  it 'calls for OAuth2 connection' do
    expect_any_instance_of(Slimpay::Resource).to receive(:oauth)
    Slimpay::Order.new
  end

  it 'generate API methods' do
    allow_any_instance_of(Slimpay::Order).to receive(:oauth)
    expect_any_instance_of(Slimpay::Order).to receive(:generate_api_methods)
    Slimpay::Order.new
  end

  it 'is a Resource child' do
    allow_any_instance_of(Slimpay::Order).to receive(:oauth)
    allow_any_instance_of(Slimpay::Order).to receive(:generate_api_methods)
    expect(Slimpay::Order.new).to be_a Slimpay::Resource
    expect(Slimpay::Order.new).to be_an_instance_of Slimpay::Order
  end

  it 'has its API methods generated' do
    allow_any_instance_of(Slimpay::Order).to receive(:oauth)
    expect(Slimpay::Order.new).to respond_to :get_orders
    expect(Slimpay::Order.new).to respond_to :get_order
    expect(Slimpay::Order.new).to respond_to :create_orders
    expect(Slimpay::Order.new).to respond_to :patch_order
  end

  it 'has a get_one method' do
    allow_any_instance_of(Slimpay::Order).to receive(:oauth)
    allow_any_instance_of(Slimpay::Order).to receive(:generate_api_methods)
    expect(Slimpay::Order.new).to respond_to :get_one
  end

  it 'has its POST methods shortcuts' do
    allow_any_instance_of(Slimpay::Order).to receive(:oauth)
    allow_any_instance_of(Slimpay::Order).to receive(:generate_api_methods)
    expect(Slimpay::Order.new).to respond_to :login
    expect(Slimpay::Order.new).to respond_to :sign_mandate
  end
end
