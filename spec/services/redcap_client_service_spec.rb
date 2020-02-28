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

  describe '#call' do
    let(:httparty) { double('HTTParty', parsed_response: parsed_response) }
    let(:redcap_client) { RedcapClientService.new }
    let(:data) do
      [{ 'record_id' => '123ABC', 'ctrl_pers_name' => 'Test' }].to_json
    end

    describe 'when HTTParty submitted then' do
      before do
        allow(redcap_client).to receive(:token).and_return('ABCD1234EFB')
        allow(redcap_client).to receive(:api_url).and_return('https://mytestapi.com/api')
        allow(HTTParty).to receive(:post).and_return(httparty)
        allow(httparty).to receive(:success?).and_return(true)
      end

      context 'success' do
        let(:parsed_response) do
          { 'count' => 1 }
        end

        it { expect(redcap_client.token).to eq('ABCD1234EFB') }
        it { expect(redcap_client.api_url).to eq('https://mytestapi.com/api') }
        it { expect(redcap_client.call(data)).to eq(true) }
      end

      context 'failed' do
        let(:parsed_response) do
          { 'count' => 0 }
        end

        it { expect(redcap_client.token).to eq('ABCD1234EFB') }
        it { expect(redcap_client.api_url).to eq('https://mytestapi.com/api') }
        it { expect(redcap_client.call(data)).to eq(false) }
      end
    end

    describe 'when HTTParty failed then' do
      before do
        allow(redcap_client).to receive(:token).and_return('ABCD1234EFB')
        allow(redcap_client).to receive(:api_url).and_return('https://mytestapi.com/api')
        allow(HTTParty).to receive(:post).and_raise(HTTParty::Error)
      end

      context 'failed' do
        it { expect(redcap_client.token).to eq('ABCD1234EFB') }
        it { expect(redcap_client.api_url).to eq('https://mytestapi.com/api') }
        it { expect(redcap_client.call(data)).to eq(false) }
      end
    end
  end
end
