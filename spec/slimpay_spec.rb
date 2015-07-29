require 'spec_helper'

describe Slimpay do
  it 'has a version number' do
    expect(Slimpay::VERSION).not_to be nil
  end

  it '.answers to nil' do
    expect(Slimpay.answer(nil)).not_to be nil
  end
end
