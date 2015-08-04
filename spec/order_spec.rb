require 'spec_helper'

describe Slimpay::Order do
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
end
