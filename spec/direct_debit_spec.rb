require 'spec_helper'

RSpec.describe Slimpay::DirectDebit do
  include_examples 'Expect OAuth and first requests', Slimpay::Base

  it 'is a Resource child' do
    allow_oauth_and_first_requests(Slimpay::DirectDebit)
    expect(Slimpay::DirectDebit.new).to be_a Slimpay::Resource
    expect(Slimpay::DirectDebit.new).to be_an_instance_of Slimpay::DirectDebit
  end

  it 'has a get_one method' do
    allow_oauth_and_first_requests(Slimpay::DirectDebit)
    expect(Slimpay::DirectDebit.new).to respond_to :get_one
  end

  it 'has its POST methods shortcuts' do
    allow_oauth_and_first_requests(Slimpay::DirectDebit)
    expect(Slimpay::DirectDebit.new).to respond_to :make_payment
  end
end
