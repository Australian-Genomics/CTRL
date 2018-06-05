require 'rails_helper'

describe RedCapManager do
  context 'get dates' do
    it 'should get the record date consent signed "ethic_cons_sign_date" and "cmdt_resul_dte"' do
      record_id = 'A0120001'
      data = { :token => '69712346139C3ED3BE4795341852A598', :content => 'record', :format => 'json', :type => 'flat', 'records[0]' => record_id, :returnFormat => 'json' }
      red_cap_url = 'https://redcap.mcri.edu.au/api/'

      parsed_response_mock = double('parsed response', first: { 'ethic_cons_sign_date' => '2017-06-28', 'cmdt_resul_dte' => '2018-01-10' })
      response_mock = double('redcap response', parsed_response: parsed_response_mock)

      expect(HTTParty).to receive(:post).with(red_cap_url, body: data).and_return(response_mock)
      expect(response_mock).to receive(:success?).and_return(true)

      dates_hash = RedCapManager.get_consent_and_result_dates(record_id)
      expect(dates_hash['ethic_cons_sign_date']).to eql('2017-06-28')
      expect(dates_hash['cmdt_resul_dte']).to eql('2018-01-10')
    end

    it 'should get a nil result if response is not successful' do
      record_id = 'A0120001'
      data = { :token => '69712346139C3ED3BE4795341852A598', :content => 'record', :format => 'json', :type => 'flat', 'records[0]' => record_id, :returnFormat => 'json' }
      red_cap_url = 'https://redcap.mcri.edu.au/api/'

      response_mock = double('redcap response')
      expect(HTTParty).to receive(:post).with(red_cap_url, body: data).and_return(response_mock)
      expect(response_mock).to receive(:success?).and_return(false)
      expect(response_mock).to_not receive(:parsed_response)

      dates_hash = RedCapManager.get_consent_and_result_dates(record_id)
      expect(dates_hash).to be_blank
    end

    it 'should get a nil result if response is successful but response its nil' do
      record_id = 'A0120001'
      data = { :token => '69712346139C3ED3BE4795341852A598', :content => 'record', :format => 'json', :type => 'flat', 'records[0]' => record_id, :returnFormat => 'json' }
      red_cap_url = 'https://redcap.mcri.edu.au/api/'

      parsed_response_mock = double('parsed response', first: nil)
      response_mock = double('redcap response', parsed_response: parsed_response_mock)

      expect(HTTParty).to receive(:post).with(red_cap_url, body: data).and_return(response_mock)
      expect(response_mock).to receive(:success?).and_return(true)

      dates_hash = RedCapManager.get_consent_and_result_dates(record_id)
      expect(dates_hash).to be_blank
    end

    it 'should get a nil result if response is successful but response its empty array' do
      record_id = 'A0120001'
      data = { :token => '69712346139C3ED3BE4795341852A598', :content => 'record', :format => 'json', :type => 'flat', 'records[0]' => record_id, :returnFormat => 'json' }
      red_cap_url = 'https://redcap.mcri.edu.au/api/'

      parsed_response_mock = double('parsed response', first: [])
      response_mock = double('redcap response', parsed_response: parsed_response_mock)

      expect(HTTParty).to receive(:post).with(red_cap_url, body: data).and_return(response_mock)
      expect(response_mock).to receive(:success?).and_return(true)

      dates_hash = RedCapManager.get_consent_and_result_dates(record_id)
      expect(dates_hash).to be_blank
    end

    it 'should return nil if there is an error with the post' do
      record_id = 'A0120001'
      data = { :token => '69712346139C3ED3BE4795341852A598', :content => 'record', :format => 'json', :type => 'flat', 'records[0]' => record_id, :returnFormat => 'json' }
      red_cap_url = 'https://redcap.mcri.edu.au/api/'

      expect(HTTParty).to receive(:post).with(red_cap_url, body: data).and_raise(HTTParty::Error)
      expect(Rollbar).to receive(:error).with('Error connecting to RedCap - HTTParty::Error')

      dates_hash = RedCapManager.get_consent_and_result_dates(record_id)
      expect(dates_hash).to be_blank
    end
  end

  context 'get survey 1 link from rare_disease_patient_survey_complete' do
    it 'should get the survey 1 link for the patient' do
      record_id = 'A0120001'
      data = { :token => '69712346139C3ED3BE4795341852A598', :content => 'surveyLink', :format => 'json', :instrument => 'rare_disease_patient_survey', 'record' => record_id, :returnFormat => 'json' }
      red_cap_url = 'https://redcap.mcri.edu.au/api/'
      survey_one_link = 'https://redcap.mcri.edu.au/surveys/?s=ChFWKExkpU'

      response_mock = double('redcap response', parsed_response: survey_one_link)

      expect(HTTParty).to receive(:post).with(red_cap_url, body: data).and_return(response_mock)
      expect(response_mock).to receive(:success?).and_return(true)

      survey_link = RedCapManager.get_survey_one_link(record_id)
      expect(survey_link).to eql(survey_one_link)
    end

    it 'should get a nil result if response is not successful' do
      record_id = 'A0120001'
      data = { :token => '69712346139C3ED3BE4795341852A598', :content => 'surveyLink', :format => 'json', :instrument => 'rare_disease_patient_survey', 'record' => record_id, :returnFormat => 'json' }
      red_cap_url = 'https://redcap.mcri.edu.au/api/'

      response_mock = double('redcap response')
      expect(HTTParty).to receive(:post).with(red_cap_url, body: data).and_return(response_mock)
      expect(response_mock).to receive(:success?).and_return(false)

      dates_hash = RedCapManager.get_survey_one_link(record_id)
      expect(dates_hash).to be_blank
    end

    it 'should return nil if there is an error with the post' do
      record_id = 'A0120001'
      data = { :token => '69712346139C3ED3BE4795341852A598', :content => 'surveyLink', :format => 'json', :instrument => 'rare_disease_patient_survey', 'record' => record_id, :returnFormat => 'json' }
      red_cap_url = 'https://redcap.mcri.edu.au/api/'

      expect(HTTParty).to receive(:post).with(red_cap_url, body: data).and_raise(HTTParty::Error)
      expect(Rollbar).to receive(:error).with('Error connecting to RedCap - HTTParty::Error')

      dates_hash = RedCapManager.get_survey_one_link(record_id)
      expect(dates_hash).to be_blank
    end
  end

  context 'get survey 1 return code from rare_disease_patient_survey_complete' do
    it 'should get the survey 1 return code for the patient' do
      record_id = 'A0120001'
      data = { :token => '69712346139C3ED3BE4795341852A598', :content => 'surveyReturnCode', :format => 'json', :instrument => 'rare_disease_patient_survey', 'record' => record_id,
               :returnFormat => 'json' }
      red_cap_url = 'https://redcap.mcri.edu.au/api/'
      survey_one_return_code = 'SDFSA34'

      response_mock = double('redcap response', parsed_response: survey_one_return_code)

      expect(HTTParty).to receive(:post).with(red_cap_url, body: data).and_return(response_mock)
      expect(response_mock).to receive(:success?).and_return(true)

      survey_link = RedCapManager.get_survey_one_return_code(record_id)
      expect(survey_link).to eql(survey_one_return_code)
    end

    it 'should get a nil result if response is not successful' do
      record_id = 'A0120001'
      data = { :token => '69712346139C3ED3BE4795341852A598', :content => 'surveyReturnCode', :format => 'json', :instrument => 'rare_disease_patient_survey', 'record' => record_id,
               :returnFormat => 'json' }
      red_cap_url = 'https://redcap.mcri.edu.au/api/'

      response_mock = double('redcap response')
      expect(HTTParty).to receive(:post).with(red_cap_url, body: data).and_return(response_mock)
      expect(response_mock).to receive(:success?).and_return(false)

      dates_hash = RedCapManager.get_survey_one_return_code(record_id)
      expect(dates_hash).to be_blank
    end

    it 'should return nil if there is an error with the post' do
      record_id = 'A0120001'
      data = { :token => '69712346139C3ED3BE4795341852A598', :content => 'surveyReturnCode', :format => 'json', :instrument => 'rare_disease_patient_survey', 'record' => record_id,
               :returnFormat => 'json' }
      red_cap_url = 'https://redcap.mcri.edu.au/api/'

      expect(HTTParty).to receive(:post).with(red_cap_url, body: data).and_raise(HTTParty::Error)
      expect(Rollbar).to receive(:error).with('Error connecting to RedCap - HTTParty::Error')

      dates_hash = RedCapManager.get_survey_one_return_code(record_id)
      expect(dates_hash).to be_blank
    end
  end

  context 'get survey 1 status for rare_disease_patient_survey_complete' do
    it 'should get the survey 1 status for the patient' do
      survey_access_code = 'GBDKSP'
      data = { token: '69712346139C3ED3BE4795341852A598', content: 'participantList', format: 'json', instrument: 'rare_disease_patient_survey', returnFormat: 'json' }
      red_cap_url = 'https://redcap.mcri.edu.au/api/'
      survey_one_return_code = '1'

      parsed_response = [
        {
          'email' => '',
          'email_occurrence' => 1,
          'identifier' => '',
          'record' => '',
          'invitation_sent_status' => 0,
          'invitation_send_time' => '',
          'response_status' => 0,
          'survey_access_code' => 'EJNX9asdfAYT9',
          'survey_link' => 'https=>//redcap.mcri.edu.au/surveys/?s=asdf'
        },
        {
          'email' => '',
          'email_occurrence' => 1,
          'identifier' => '',
          'record' => '',
          'invitation_sent_status' => 0,
          'invitation_send_time' => '',
          'response_status' => survey_one_return_code,
          'survey_access_code' => survey_access_code,
          'survey_link' => 'https=>//redcap.mcri.edu.au/surveys/?s=hgsgff'
        }
      ]

      response_mock = double('redcap response', parsed_response: parsed_response)

      expect(HTTParty).to receive(:post).with(red_cap_url, body: data).and_return(response_mock)
      expect(response_mock).to receive(:success?).and_return(true)

      survey_one_status = RedCapManager.get_survey_one_status(survey_access_code)
      expect(survey_one_status).to eql(survey_one_return_code)
    end

    it 'should return nil if it has no info' do
      survey_access_code = 'GBDKSP'
      data = { token: '69712346139C3ED3BE4795341852A598', content: 'participantList', format: 'json', instrument: 'rare_disease_patient_survey', returnFormat: 'json' }
      red_cap_url = 'https://redcap.mcri.edu.au/api/'
      survey_one_return_code = '1'

      parsed_response = [
        {
          'email' => '',
          'email_occurrence' => 1,
          'identifier' => '',
          'record' => '',
          'invitation_sent_status' => 0,
          'invitation_send_time' => '',
          'response_status' => 0,
          'survey_access_code' => survey_access_code,
          'survey_link' => 'https=>//redcap.mcri.edu.au/surveys/?s=asdf'
        },
        {
          'email' => '',
          'email_occurrence' => 1,
          'identifier' => '',
          'record' => '',
          'invitation_sent_status' => 0,
          'invitation_send_time' => '',
          'response_status' => survey_one_return_code,
          'survey_access_code' => survey_access_code,
          'survey_link' => 'https=>//redcap.mcri.edu.au/surveys/?s=hgsgff'
        }
      ]

      response_mock = double('redcap response', parsed_response: parsed_response)

      expect(HTTParty).to receive(:post).with(red_cap_url, body: data).and_return(response_mock)
      expect(response_mock).to receive(:success?).and_return(true)

      survey_one_status = RedCapManager.get_survey_one_status('')
      expect(survey_one_status).to be_blank
    end

    it 'should get a nil result if response is not successful' do
      record_id = 'A0120001'
      data = { token: '69712346139C3ED3BE4795341852A598', content: 'participantList', format: 'json', instrument: 'rare_disease_patient_survey', returnFormat: 'json' }
      red_cap_url = 'https://redcap.mcri.edu.au/api/'

      response_mock = double('redcap response')
      expect(HTTParty).to receive(:post).with(red_cap_url, body: data).and_return(response_mock)
      expect(response_mock).to receive(:success?).and_return(false)

      dates_hash = RedCapManager.get_survey_one_status(record_id)
      expect(dates_hash).to be_blank
    end

    it 'should return nil if there is an error with the post' do
      record_id = 'A0120001'
      data = { token: '69712346139C3ED3BE4795341852A598', content: 'participantList', format: 'json', instrument: 'rare_disease_patient_survey', returnFormat: 'json' }
      red_cap_url = 'https://redcap.mcri.edu.au/api/'

      expect(HTTParty).to receive(:post).with(red_cap_url, body: data).and_raise(HTTParty::Error)
      expect(Rollbar).to receive(:error).with('Error connecting to RedCap - HTTParty::Error')

      dates_hash = RedCapManager.get_survey_one_status(record_id)
      expect(dates_hash).to be_blank
    end
  end
end
