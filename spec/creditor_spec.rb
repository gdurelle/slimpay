require 'spec_helper'

RSpec.describe Slimpay::Creditor do
  include_examples 'Expect OAuth and first requests', Slimpay::Base

  it 'is a Resource child' do
    allow_oauth_and_first_requests(Slimpay::Creditor)
    expect(Slimpay::Creditor.new).to be_a Slimpay::Resource
    expect(Slimpay::Creditor.new).to be_an_instance_of Slimpay::Creditor
  end

  it 'has a get_one method' do
    allow_oauth_and_first_requests(Slimpay::Creditor)
    expect(Slimpay::Creditor.new).to respond_to :get_one
  end

end
