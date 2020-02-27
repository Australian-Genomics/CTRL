require 'rails_helper'

RSpec.describe RedcapClientService do

  describe '#new' do
    let(:redcap_client) { RedcapClientService.new }

    before do
      allow(redcap_client).to receive(:token).and_return('ABCD1234EFB')
      allow(redcap_client).to receive(:api_url).and_return('https://mytestapi.com/api')
    end

    it { expect(redcap_client.token).to eq('ABCD1234EFB') }
    it { expect(redcap_client.api_url).to eq('https://mytestapi.com/api') }
  end
end