require 'spec_helper'

module Slimpay
  describe Configuration do
    describe 'credentials' do
      it 'defaults are sandbox' do
        expect(subject.client_id).to eql(Slimpay::SANDBOX_CLIENT_ID)
        expect(subject.client_secret).to eql(Slimpay::SANDBOX_SECRET_ID)
        expect(subject.creditor_reference).to eql(Slimpay::SANDBOX_CREDITOR)
      end
    end

    describe 'client_id=' do
      it 'can set value' do
        subject.client_id = 'testconfigidaccessor'
        expect(subject.client_id).to eq('testconfigidaccessor')
      end
    end
  end
end
