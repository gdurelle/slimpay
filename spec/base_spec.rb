require 'spec_helper'

RSpec.describe Slimpay::Base do
  include_examples 'Expect OAuth and first requests', Slimpay::Base

  describe '#generate_api_methods' do
    let(:methods) do
      {
        '_links' =>
          {'https://api.slimpay.net/alps#lorem' => {'href' => 'https://api.slimpay.net/alps#lorem'},
           'https://api.slimpay.net/alps#ipsum' => {'href' => 'https://api.slimpay.net/alps#ipsum'}}
      }
    end
    let(:next_methods) do
      {
        '_links' =>
          {'https://api.slimpay.net/alps#dolor_sit' => {'href' => 'https://api.slimpay.net/alps#dolor_sit'},
           'https://api.slimpay.net/alps#amet' => {'href' => 'https://api.slimpay.net/alps#amet'}}
      }
    end
    let(:list_methods) {{'lorem' => 'https://api.slimpay.net/alps#lorem', 'ipsum' => 'https://api.slimpay.net/alps#ipsum'}}
    let(:next_list_methods) {{'dolor_sit' => 'https://api.slimpay.net/alps#dolor_sit', 'amet' => 'https://api.slimpay.net/alps#amet'}}

    it 'generate methods with proper names each time' do
      allow_any_instance_of(Slimpay::Base).to receive(:connect_api_with_oauth)
      allow_any_instance_of(Slimpay::Base).to receive(:request_to_api) {methods.to_json}
      slim = Slimpay::Base.new
      expect(slim.send(:api_methods)).to eql(list_methods)
      slim.generate_api_methods(next_methods)
      expect(slim.send(:api_methods)).to eql(list_methods.merge(next_list_methods))
    end
  end

  describe '#connect_api_with_oauth', vcr: {cassette_name: 'oauth'} do
    it "calls Slimpay's OAuth2 server and retrieve token" do
      allow_any_instance_of(Slimpay::Base).to receive(:request_to_api) {{plop: 'lorem'}.to_json}
      allow_any_instance_of(Slimpay::Base).to receive(:generate_api_methods)
      slim = Slimpay::Base.new
      token = slim.instance_variable_get(:@token)
      expect(token).not_to be_nil
      expect(token).to be_kind_of(String)
    end
  end

  describe '#request_to_api', vcr: {cassette_name: 'slimpay_root_endpoint'} do
    it 'calls Slimpay HAPI root endpoint' do
      slim = Slimpay::Base.new
      expect(slim.api_methods).to be_kind_of(Hash)
      expect(slim.api_methods.keys).to include('create_orders', 'get_direct_debits')
    end
  end
end
