require 'spec_helper'

RSpec.describe UploadRedcapDetailsJob do
  describe '#call_api' do
    let(:mock_redcap_url) { 'example.com' }

    it 'does nothing when REDCAP_CONNECTION_ENABLED == false' do
      allow(HTTParty).to receive(:post)
      stub_const('REDCAP_CONNECTION_ENABLED', false)

      payload = {'this is' => 'a payload'}
      UploadRedcapDetailsJob.new.call_api(payload)
      expect(HTTParty).not_to receive(:post)
    end

    it 'posts the payload when REDCAP_CONNECTION_ENABLED == true' do
      parsed_response = {'count' => 1}
      httparty = double('HTTParty', parsed_response: parsed_response)
      allow(httparty).to receive(:success?).and_return(true)
      allow(HTTParty).to receive(:post).and_return(httparty)
      stub_const('REDCAP_API_URL', mock_redcap_url)
      stub_const('REDCAP_CONNECTION_ENABLED', true)

      payload = {'this is' => 'a payload'}
      UploadRedcapDetailsJob.new.call_api(payload)
      expect(HTTParty).to have_received(:post)
        .with(mock_redcap_url, body: payload)
    end

    it 'raises an exception when REDCap is down' do
      allow(HTTParty).to receive(:post).and_raise(HTTParty::Error)
      allow(Rollbar).to receive(:error)
      stub_const('REDCAP_API_URL', mock_redcap_url)
      stub_const('REDCAP_CONNECTION_ENABLED', true)

      payload = {'this is' => 'a payload'}

      expect {
        UploadRedcapDetailsJob.new.call_api(payload)
      }.to raise_error(HTTParty::Error)

      expect(HTTParty).to have_received(:post)
        .with(mock_redcap_url, body: payload)
      expect(Rollbar).to have_received(:error)
        .with('Error connecting to REDCap - HTTParty::Error')
    end
  end

  describe '#make_redcap_api_payload' do
    it 'returns a payload when passed data' do
      mock_data = 'my data'
      mock_redcap_token = 'redcap token'

      stub_const('REDCAP_TOKEN', mock_redcap_token)
      expected_payload = {
        token: mock_redcap_token,
        content: 'record',
        format: 'json',
        type: 'flat',
        data: mock_data,
      }

      expect(UploadRedcapDetailsJob.new.make_redcap_api_payload(mock_data)).to eq(expected_payload)
    end

    it 'returns nil when passed nil' do
      expect(UploadRedcapDetailsJob.new.make_redcap_api_payload(nil)).to eq(nil)
    end
  end

  describe '#fetch_redcap_code' do
    it 'returns the stored REDCap code for "yes" when present' do
      actual_redcap_code = UploadRedcapDetailsJob.new
        .fetch_redcap_code(create(:consent_question, :multiple_choice), 'yes')
      expect(actual_redcap_code).to eq("11")
    end

    it 'returns the stored REDCap code for "no" when present' do
      actual_redcap_code = UploadRedcapDetailsJob.new
        .fetch_redcap_code(create(:consent_question, :multiple_choice), 'no')
      expect(actual_redcap_code).to eq("10")
    end

    it 'returns the default REDCap code for "yes" when absent' do
      actual_redcap_code = UploadRedcapDetailsJob.new
        .fetch_redcap_code(create(:consent_question), 'yes')
      expect(actual_redcap_code).to eq("1")
    end

    it 'returns the default REDCap code for "no" when absent' do
      actual_redcap_code = UploadRedcapDetailsJob.new
        .fetch_redcap_code(create(:consent_question), 'no')
      expect(actual_redcap_code).to eq("0")
    end
  end

  describe '#collect_data' do
    it 'collects data to tick checkboxes' do
      question_answer = create(:question_answer, traits: [:multiple_checkboxes, :with_redcap_field])
      actual_data = UploadRedcapDetailsJob.new
        .collect_data(question_answer.id, true)
      expected_data = [
        {
          "record_id" => question_answer.user_id,
          "redcap_field_name___11" => "0"
        }
      ].to_json

      expect(actual_data).to eq(expected_data)
    end

    it 'collects data to untick checkboxes' do
      question_answer = create(:question_answer, traits: [:multiple_checkboxes, :with_redcap_field])
      actual_data = UploadRedcapDetailsJob.new
        .collect_data(question_answer.id, false)
      expected_data = [
        {
          "record_id" => question_answer.user_id,
          "redcap_field_name___11" => "1"
        }
      ].to_json

      expect(actual_data).to eq(expected_data)
    end

    it 'collects data to set fields other than checkboxes' do
      question_answer = create(:question_answer, traits: [:with_redcap_field])
      actual_data = UploadRedcapDetailsJob.new
        .collect_data(question_answer.id, false)
      expected_data = [
        {
          "record_id" => question_answer.user_id,
          "redcap_field_name" => "1"
        }
      ].to_json

      expect(actual_data).to eq(expected_data)
    end
  end

  describe '#perform' do
    it 'updates REDCap when there are updates to do' do
      uploader = UploadRedcapDetailsJob.new

      allow(uploader).to receive(:collect_data).and_return(:data)
      allow(uploader).to receive(:make_redcap_api_payload).and_return(:payload)
      allow(uploader).to receive(:call_api)
      uploader.perform('id', false)
      expect(uploader).to have_received(:make_redcap_api_payload).with(:data)
      expect(uploader).to have_received(:call_api).with(:payload)
    end

    it 'does not update REDCap when there are no updates to do' do
      uploader = UploadRedcapDetailsJob.new

      allow(uploader).to receive(:collect_data).and_return(:data)
      allow(uploader).to receive(:make_redcap_api_payload).and_return(nil)
      allow(uploader).to receive(:call_api)
      uploader.perform('id', false)
      expect(uploader).not_to have_received(:call_api)
    end
  end

end
