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

  describe '#configure' do
    before do
      Slimpay.configure do |config|
        config.client_id = 'testcreditor01'
        config.client_secret = 'testsecret01'
        config.creditor_reference = 'testcreditor'
      end
    end

    it 'initializes the variables according the config' do
      expect(Slimpay.configuration.client_id).to eq('testcreditor01')
      expect(Slimpay.configuration.client_secret).to eq('testsecret01')
      expect(Slimpay.configuration.creditor_reference).to eq('testcreditor')
    end
  end
end
