require 'spec_helper'

describe Slimpay::Base do
  include_examples 'Expect OAuth and first requests', Slimpay::Base

  describe '#generate_api_methods' do
    let(:methods) do
      { '_links' =>
          { 'https://api.slimpay.net/alps#lorem' => { 'href' => 'https://api.slimpay.net/alps#lorem' },
          'https://api.slimpay.net/alps#ipsum' => { 'href' => 'https://api.slimpay.net/alps#ipsum' } }
      }
    end
    let(:next_methods) do
      { '_links' =>
          { 'https://api.slimpay.net/alps#dolor_sit' => { 'href' => 'https://api.slimpay.net/alps#dolor_sit' },
          'https://api.slimpay.net/alps#amet' => { 'href' => 'https://api.slimpay.net/alps#amet' } }
      }
    end
    let(:list_methods) { { 'lorem' => 'https://api.slimpay.net/alps#lorem', 'ipsum' => 'https://api.slimpay.net/alps#ipsum' } }
    let(:next_list_methods) { { 'dolor_sit' => 'https://api.slimpay.net/alps#dolor_sit', 'amet' => 'https://api.slimpay.net/alps#amet' } }
    it 'generate methods with proper names each time' do
      allow_any_instance_of(Slimpay::Base).to receive(:connect_api_with_oauth)
      allow_any_instance_of(Slimpay::Base).to receive(:request_to_api) { methods.to_json }
      slim = Slimpay::Base.new
      expect(slim.send(:api_methods)).to eql(list_methods)
      slim.generate_api_methods(next_methods)
      expect(slim.send(:api_methods)).to eql(list_methods.merge(next_list_methods))
    end
  end
end
