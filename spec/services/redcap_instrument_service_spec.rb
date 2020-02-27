require 'rails_helper'

RSpec.describe RedcapInstrumentService do
  let(:user) { FactoryBot.create(:user) }
  let(:step) { FactoryBot.create(:step, number: 4, accepted: true, user: user) }
  let!(:question) { FactoryBot.create(:question, question_id: 16, answer: 1, step: step) }
  let!(:question_two) { FactoryBot.create(:question, question_id: 17, answer: 2, step: step) }
  let(:redcap_client) { double('RedcapClientService') }
  let(:httparty) { double('HTTParty', parsed_response: { 'count' => 1 }) }
  let(:redcap_instrument) { RedcapInstrumentService.new(step.id) }

  before do
    allow(redcap_client).to receive(:token).and_return('ABCD1234EFB')
    allow(redcap_client).to receive(:api_url).and_return('https://mytestapi.com/api')
    allow(HTTParty).to receive(:post).and_return(httparty)
    allow(httparty).to receive(:success?).and_return(true)
  end

  describe '#new' do
    it { expect(redcap_instrument.client).to be_a(RedcapClientService) }
    it { expect(redcap_instrument.step).to be_a(Step) }
    it { expect(redcap_instrument.step).to eq(step) }
  end

  describe '#call' do
    it { expect(redcap_instrument.client).to be_a(RedcapClientService) }
    it { expect(redcap_instrument.step).to be_a(Step) }
    it { expect(redcap_instrument.step).to eq(step) }
    it { expect(redcap_instrument.update).to eq(true) }
  end
end
