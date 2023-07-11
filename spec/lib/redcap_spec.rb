require 'spec_helper'
require 'ostruct'

RSpec.describe Redcap do
  describe '#filter_repeat_instruments' do
    it 'returns nil when passed nil' do
      expect(Redcap.filter_repeat_instruments(nil)).to eq(nil)
    end

    it 'filters out REDCap repeating instruments' do
      record1 = {
        'record_id' => '10',
        'redcap_event_name' => 'proband_informatio_arm_1',
        'redcap_repeat_instrument' => 'qwer',
        'redcap_repeat_instance' => '1',
        'site' => ''
      }
      record2 = {
        'record_id' => '11',
        'redcap_event_name' => 'proband_informatio_arm_1',
        'site' => ''
      }
      record3 = {
        'record_id' => '12',
        'redcap_event_name' => 'proband_informatio_arm_1',
        'redcap_repeat_instrument' => '',
        'redcap_repeat_instance' => '',
        'site' => ''
      }
      record4 = {
        'record_id' => '13',
        'redcap_event_name' => 'proband_informatio_arm_1',
        'redcap_repeat_instrument' => 'asdf',
        'redcap_repeat_instance' => '2',
        'site' => ''
      }

      records = [
        record1,
        record2,
        record3,
        record4
      ]

      expect(Redcap.filter_repeat_instruments(records)).to eq([record2, record3])
    end
  end

  describe '#call_api' do
    let(:mock_redcap_url) { 'example.com' }

    it 'does nothing when REDCAP_CONNECTION_ENABLED == false' do
      allow(HTTParty).to receive(:post)
      stub_const('REDCAP_CONNECTION_ENABLED', false)

      payload = { 'this is' => 'a payload' }
      Redcap.call_api(payload)
      expect(HTTParty).not_to receive(:post)
    end

    it 'posts the payload when REDCAP_CONNECTION_ENABLED == true' do
      parsed_response = { 'count' => 1 }
      httparty = double('HTTParty', parsed_response: parsed_response)
      allow(httparty).to receive(:success?).and_return(true)
      allow(HTTParty).to receive(:post).and_return(httparty)
      stub_const('REDCAP_API_URL', mock_redcap_url)
      stub_const('REDCAP_CONNECTION_ENABLED', true)

      payload = { 'this is' => 'a payload' }
      Redcap.call_api(payload)
      expect(HTTParty).to have_received(:post)
        .with(mock_redcap_url, body: payload)
    end

    it 'raises an exception when REDCap is down' do
      allow(HTTParty).to receive(:post).and_raise(HTTParty::Error)
      allow(Rollbar).to receive(:error)
      stub_const('REDCAP_API_URL', mock_redcap_url)
      stub_const('REDCAP_CONNECTION_ENABLED', true)

      payload = { 'this is' => 'a payload' }

      expect do
        Redcap.call_api(payload)
      end.to raise_error(HTTParty::Error)

      expect(HTTParty).to have_received(:post)
        .with(mock_redcap_url, body: payload)
      expect(Rollbar).to have_received(:error)
        .with('Error connecting to REDCap - HTTParty::Error')
    end

    it 'raises an exception when the count is unexpected' do
      parsed_response = { 'count' => 42 }
      httparty = double('HTTParty', parsed_response: parsed_response)
      allow(httparty).to receive(:success?).and_return(true)
      allow(HTTParty).to receive(:post).and_return(httparty)
      stub_const('REDCAP_API_URL', mock_redcap_url)
      stub_const('REDCAP_CONNECTION_ENABLED', true)

      payload = { 'this is' => 'a payload' }

      expect do
        Redcap.call_api(payload, expected_count: 43)
      end.to raise_error(StandardError)
    end

    it 'returns the parsed response when the count is expected' do
      parsed_response = { 'count' => 42 }
      httparty = double('HTTParty', parsed_response: parsed_response)
      allow(httparty).to receive(:success?).and_return(true)
      allow(HTTParty).to receive(:post).and_return(httparty)
      stub_const('REDCAP_API_URL', mock_redcap_url)
      stub_const('REDCAP_CONNECTION_ENABLED', true)

      payload = { 'this is' => 'a payload' }

      expect(Redcap.call_api(payload, expected_count: 42)).to eq(parsed_response)
    end
  end

  describe '#get_import_payload' do
    it 'returns a payload when passed data' do
      mock_data = 'my data'
      mock_redcap_token = 'redcap token'

      stub_const('REDCAP_TOKEN', mock_redcap_token)
      expected_payload = {
        token: mock_redcap_token,
        content: 'record',
        format: 'json',
        type: 'flat',
        data: '"my data"'
      }

      expect(Redcap.get_import_payload(mock_data)).to eq(expected_payload)
    end

    it 'returns nil when passed nil' do
      expect(Redcap.get_import_payload(nil)).to eq(nil)
    end
  end

  describe '#get_export_payload' do
    it 'returns a payload when passed data' do
      mock_redcap_token = 'redcap token'
      mock_participant_id = 'my-participant-id'
      mock_event_name = 'my-event-name'

      mock_data = OpenStruct.new(
        record_id: mock_participant_id,
        event_name: mock_event_name
      )

      stub_const('REDCAP_TOKEN', mock_redcap_token)
      expected_payload = {
        token: mock_redcap_token,
        content: 'record',
        action: 'export',
        format: 'json',
        type: 'flat',
        csvDelimiter: '',
        'records[0]': mock_participant_id,
        'events[0]': mock_event_name,
        rawOrLabel: 'raw',
        rawOrLabelHeaders: 'raw',
        exportCheckboxLabel: 'false',
        exportSurveyFields: 'false',
        exportDataAccessGroups: 'false',
        returnFormat: 'json'
      }

      expect(Redcap.get_export_payload(mock_data)).to eq(expected_payload)
    end

    it 'returns a payload when passed data with a nil event name' do
      mock_redcap_token = 'redcap token'
      mock_participant_id = 'my-participant-id'

      mock_data = OpenStruct.new(
        record_id: mock_participant_id,
        event_name: nil
      )

      stub_const('REDCAP_TOKEN', mock_redcap_token)
      expected_payload = {
        token: mock_redcap_token,
        content: 'record',
        action: 'export',
        format: 'json',
        type: 'flat',
        csvDelimiter: '',
        'records[0]': mock_participant_id,
        rawOrLabel: 'raw',
        rawOrLabelHeaders: 'raw',
        exportCheckboxLabel: 'false',
        exportSurveyFields: 'false',
        exportDataAccessGroups: 'false',
        returnFormat: 'json'
      }

      expect(Redcap.get_export_payload(mock_data)).to eq(expected_payload)
    end

    it 'returns nil when passed nil' do
      expect(Redcap.get_export_payload(nil)).to eq(nil)
    end
  end

  describe '#answer_string_to_code' do
    it 'returns "1" for the answer string "Yes"' do
      expect(Redcap.answer_string_to_code('Yes')).to eq('1')
    end
    it 'returns "0" for the answer string "No"' do
      expect(Redcap.answer_string_to_code('No')).to eq('0')
    end
    it 'returns nil for an answer string other than "Yes" or "No"' do
      expect(Redcap.answer_string_to_code('Maybe')).to eq(nil)
    end
  end

  describe '#question_answer_to_redcap_response' do
    it 'passes the right arguments to construct_redcap_response when when the redcap_event_name is blank' do
      question_answer = create(
        :question_answer,
        traits: %i[
          multiple_checkboxes
          with_redcap_field
        ]
      )

      allow(Redcap).to receive(:construct_redcap_response).and_return(:response)
      actual = Redcap.question_answer_to_redcap_response(
        record: question_answer,
        destroy: false
      )
      expect(Redcap).to have_received(:construct_redcap_response).with(
        '11',
        'redcap_field_name',
        nil,
        'yes',
        'multiple checkboxes',
        question_answer.user.participant_id,
        false
      )
      expect(actual).to eq(:response)
    end

    it 'passes the right arguments to construct_redcap_response when when the redcap_event_name is filled' do
      question_answer = create(
        :question_answer,
        traits: %i[
          multiple_checkboxes
          with_redcap_field
          with_redcap_event_name
        ]
      )

      allow(Redcap).to receive(:construct_redcap_response).and_return(:response)
      actual = Redcap.question_answer_to_redcap_response(
        record: question_answer,
        destroy: false
      )
      expect(Redcap).to have_received(:construct_redcap_response).with(
        '11',
        'redcap_field_name',
        'redcap_event_name',
        'yes',
        'multiple checkboxes',
        question_answer.user.participant_id,
        false
      )
      expect(actual).to eq(:response)
    end
  end

  describe '#construct_redcap_response' do
    it 'returns nil when raw_redcap_field is blank' do
      actual = Redcap.construct_redcap_response(
        'my_raw_redcap_code',
        nil,
        nil,
        'my_answer_string',
        'my_question_type',
        'my_user_id',
        false
      )
      expect(actual).to eq(nil)
    end

    it 'uses the answer string to determine the code when none is given' do
      allow(Redcap).to receive(:answer_string_to_code).and_return('my_answer_string')

      actual = Redcap.construct_redcap_response(
        nil,
        'my_raw_redcap_field',
        nil,
        'yes',
        'my_question_type',
        'my_user_id',
        false
      )
      expect(actual).to eq([{ 'record_id' => 'my_user_id',
                              'my_raw_redcap_field' => 'my_answer_string' }])
    end

    it 'produces the correct response for question_type == "multiple checkboxes"' do
      actual_do_destroy = Redcap.construct_redcap_response(
        'my_raw_redcap_code',
        'my_raw_redcap_field',
        nil,
        'my_answer_string',
        'multiple checkboxes',
        'my_user_id',
        true
      )
      actual_do_not_destroy = Redcap.construct_redcap_response(
        'my_raw_redcap_code',
        'my_raw_redcap_field',
        nil,
        'my_answer_string',
        'multiple checkboxes',
        'my_user_id',
        false
      )
      expect(actual_do_destroy).to eq(
        [{ 'record_id' => 'my_user_id',
           'my_raw_redcap_field___my_raw_redcap_code' => '0' }]
      )
      expect(actual_do_not_destroy).to eq(
        [{ 'record_id' => 'my_user_id',
           'my_raw_redcap_field___my_raw_redcap_code' => '1' }]
      )
    end

    it 'produces the correct response for question_type != "multiple checkboxes"' do
      actual_do_destroy = Redcap.construct_redcap_response(
        'my_raw_redcap_code',
        'my_raw_redcap_field',
        nil,
        'my_answer_string',
        'my_question_type',
        'my_user_id',
        true
      )
      actual_do_not_destroy = Redcap.construct_redcap_response(
        'my_raw_redcap_code',
        'my_raw_redcap_field',
        nil,
        'my_answer_string',
        'my_question_type',
        'my_user_id',
        false
      )
      expect(actual_do_destroy).to eq(
        [{ 'record_id' => 'my_user_id',
           'my_raw_redcap_field' => 'my_raw_redcap_code' }]
      )
      expect(actual_do_not_destroy).to eq(
        [{ 'record_id' => 'my_user_id',
           'my_raw_redcap_field' => 'my_raw_redcap_code' }]
      )
    end

    it 'uses adds the redcap_event_name when one is provided' do
      allow(Redcap).to receive(:answer_string_to_code).and_return('my_answer_string')

      actual = Redcap.construct_redcap_response(
        nil,
        'my_raw_redcap_field',
        'my_raw_redcap_event_name',
        'yes',
        'my_question_type',
        'my_user_id',
        false
      )
      expect(actual).to eq([{ 'record_id' => 'my_user_id',
                              'my_raw_redcap_field' => 'my_answer_string',
                              'redcap_event_name' => 'my_raw_redcap_event_name' }])
    end
  end

  describe '#user_to_export_redcap_response' do
    it 'produces the correct response for UserColumnToRedcapFieldMapping.count == 0' do
      user = create(:user)
      expected_response = OpenStruct.new(
        record_id: user.participant_id,
        event_name: nil
      )
      expect(Redcap.user_to_export_redcap_response(record: user)).to eq(expected_response)
    end

    it 'produces the correct response for UserColumnToRedcapFieldMapping when email is set and not blank' do
      user = create(:user)

      create(
        :user_column_to_redcap_field_mapping,
        user_column: 'email',
        redcap_field: 'ctrl_email',
        redcap_event_name: 'proband_informatio_arm_1'
      )

      expected_response = OpenStruct.new(
        record_id: user.participant_id,
        event_name: 'proband_informatio_arm_1'
      )

      expect(Redcap.user_to_export_redcap_response(record: user)).to eq(expected_response)
    end

    it 'produces the correct response for UserColumnToRedcapFieldMapping when email is set and blank' do
      user = create(:user)

      create(
        :user_column_to_redcap_field_mapping,
        user_column: 'email',
        redcap_field: 'ctrl_email',
        redcap_event_name: ''
      )

      expected_response = OpenStruct.new(
        record_id: user.participant_id,
        event_name: nil
      )

      expect(Redcap.user_to_export_redcap_response(record: user)).to eq(expected_response)
    end
  end

  describe '#user_to_import_redcap_response' do
    it 'produces the correct response for UserColumnToRedcapFieldMapping.count == 0' do
      user = create(:user)
      expect(Redcap.user_to_import_redcap_response(record: user)).to eq(nil)
    end

    it 'produces the correct response for UserColumnToRedcapFieldMapping.count > 0' do
      study_user = create(:study_user)
      user = User.find(study_user.user_id)

      create(
        :user_column_to_redcap_field_mapping,
        user_column: 'dob',
        redcap_field: 'ctrl_dob',
        redcap_event_name: 'proband_informatio_arm_1'
      )
      create(
        :user_column_to_redcap_field_mapping,
        user_column: 'email',
        redcap_field: 'ctrl_email',
        redcap_event_name: 'proband_informatio_arm_1'
      )
      create(
        :user_column_to_redcap_field_mapping,
        user_column: 'is_parent',
        redcap_field: 'ctrl_is_parent',
        redcap_event_name: 'proband_informatio_arm_1'
      )
      create(
        :user_column_to_redcap_field_mapping,
        user_column: 'family_name',
        redcap_field: 'ctrl_family_name',
        redcap_event_name: ''
      )
      create(
        :user_column_to_redcap_field_mapping,
        user_column: 'state',
        redcap_field: 'ctrl_state',
        redcap_event_name: ''
      )

      actual = Redcap.user_to_import_redcap_response(record: user)
      expected = [
        { 'record_id' => study_user.participant_id,
          'redcap_event_name' => 'proband_informatio_arm_1',
          'ctrl_dob' => user.dob },
        { 'record_id' => study_user.participant_id,
          'redcap_event_name' => 'proband_informatio_arm_1',
          'ctrl_email' => user.email },
        { 'record_id' => study_user.participant_id,
          'redcap_event_name' => 'proband_informatio_arm_1',
          'ctrl_is_parent' => '1' },
        { 'record_id' => study_user.participant_id,
          'ctrl_family_name' => user.family_name }
      ]
      expect(actual).to eq(expected)
    end
  end

  describe '#perform' do
    it 'updates REDCap when there are updates to do' do
      allow(Redcap).to receive(:question_answer_to_redcap_response).and_return(:data)
      allow(Redcap).to receive(:get_import_payload).and_return(:payload)
      allow(Redcap).to receive(:call_api)
      Redcap.perform(:question_answer_to_redcap_response, :get_import_payload, record: 'id', destroy: false)
      expect(Redcap).to have_received(:get_import_payload).with(:data)
      expect(Redcap).to have_received(:call_api).with(:payload, destroy: false)
    end

    it 'does not update REDCap when there are no updates to do' do
      allow(Redcap).to receive(:question_answer_to_redcap_response).and_return(nil)
      allow(Redcap).to receive(:get_import_payload)
      allow(Redcap).to receive(:call_api)
      Redcap.perform(:question_answer_to_redcap_response, :get_import_payload, record: 'id', destroy: false)
      expect(Redcap).not_to have_received(:get_import_payload)
      expect(Redcap).not_to have_received(:call_api)
    end
  end
end
