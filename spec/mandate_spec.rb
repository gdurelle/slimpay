require 'spec_helper'

RSpec.describe Slimpay::Mandate do
  include_examples 'Expect OAuth and first requests', Slimpay::Mandate

  subject {Slimpay::Mandate}

  it 'is a Resource child' do
    allow_oauth_and_first_requests(Slimpay::Mandate)
    expect(subject.new).to be_a Slimpay::Resource
    expect(subject.new).to be_an_instance_of Slimpay::Mandate
  end

  it 'has a get_one method' do
    allow_oauth_and_first_requests(Slimpay::Mandate)
    expect(subject.new).to respond_to :get_one
  end
end
