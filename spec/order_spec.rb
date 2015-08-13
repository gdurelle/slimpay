require 'spec_helper'

RSpec.describe Slimpay::Order do
  include_examples 'Expect OAuth and first requests', Slimpay::Base

  it 'is a Resource child' do
    allow_oauth_and_first_requests(Slimpay::Order)
    expect(Slimpay::Order.new).to be_a Slimpay::Resource
    expect(Slimpay::Order.new).to be_an_instance_of Slimpay::Order
  end

  it 'has a get_one method' do
    allow_oauth_and_first_requests(Slimpay::Order)
    expect(Slimpay::Order.new).to respond_to :get_one
  end

  it 'has its POST methods shortcuts' do
    allow_oauth_and_first_requests(Slimpay::Order)
    expect(Slimpay::Order.new).to respond_to :login
    expect(Slimpay::Order.new).to respond_to :sign_mandate
  end

  describe '#sign_mandate', vcr: { cassette_name: 'order_sign_mandate' } do
    it 'starts a mandate signature with sandbox' do
      orders = Slimpay::Order.new
      order = orders.sign_mandate
      expect(order).to be_kind_of(Hash)
      expect(order['reference']).to be_kind_of(String)
      expect(order['state']).to be_kind_of(String)
      expect(order['state']).to eq('open.running')
      expect(orders.api_methods.keys).to include('user_approval')
    end
  end
end
