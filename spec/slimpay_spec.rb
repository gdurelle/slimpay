require 'spec_helper'

describe Slimpay do
  it 'has a version number' do
    expect(Slimpay::VERSION).not_to be nil
  end

  it 'answers to nil HTTP responses' do
    expect(Slimpay.answer(nil)).not_to be nil
  end

  it 'defines API constants' do
    expect(Slimpay::PRODUCTION_ENDPOINT).not_to be nil
    expect(Slimpay::PRODUCTION_ENDPOINT).to eq 'https://api.slimpay.net'
    expect(Slimpay::API_HEADER).not_to be nil
    expect(Slimpay::API_HEADER).to match 'https://api.slimpay.net'
    expect(Slimpay::SANDBOX_ENDPOINT).not_to be nil
    expect(Slimpay::SANDBOX_ENDPOINT).to eq 'https://api-sandbox.slimpay.net'
  end
end
