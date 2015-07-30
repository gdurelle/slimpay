require 'spec_helper'

describe Slimpay::Error do
  it 'returns an explanation for empty HTTP responses' do
    expect(Slimpay::Error.empty).to eq(code: 418, message: 'The answer was empty.')
  end
end
