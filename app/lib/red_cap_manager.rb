class RedCapManager
  RED_CAP_URL = ENV['RED_CAP_URL']
  RED_CAP_TOKEN = ENV['RED_CAP_TOKEN']

  def self.get_consent_and_result_dates(participant_id)
    data = { :token => RED_CAP_TOKEN, :content => 'record', :format => 'json', :type => 'flat', 'records[0]' => participant_id, :returnFormat => 'json' }

    begin
      response = HTTParty.post(RED_CAP_URL, body: data)
      if response.success? && response.parsed_response.present? && response.parsed_response.first.present?
        participant_data = response.parsed_response.first
        return participant_data.slice('ethic_cons_sign_date', 'cmdt_resul_dte')
      end
    rescue HTTParty::Error, SocketError => e
      Rollbar.error("Error connecting to RedCap - #{e.message}")
    end
  end

  def self.get_survey_one_link(participant_id, survey_instrument)
    data = { :token => RED_CAP_TOKEN, :content => 'surveyLink', :format => 'json', :instrument => survey_instrument, 'record' => participant_id,
             :returnFormat => 'json' }

    begin
      response = HTTParty.post(RED_CAP_URL, body: data)
      return response.parsed_response if response.success? && response.parsed_response.present?
    rescue HTTParty::Error, SocketError => e
      Rollbar.error("Error connecting to RedCap - #{e.message}")
    end
  end

  def self.get_survey_one_return_code(participant_id, survey_instrument)
    data = { :token => RED_CAP_TOKEN, :content => 'surveyReturnCode', :format => 'json', :instrument => survey_instrument, 'record' => participant_id,
             :returnFormat => 'json' }

    begin
      response = HTTParty.post(RED_CAP_URL, body: data)
      return response.parsed_response if response.success? && response.parsed_response.present?
    rescue HTTParty::Error, SocketError => e
      Rollbar.error("Error connecting to RedCap - #{e.message}")
    end
  end

  def self.get_survey_one_status(survey_link, survey_instrument)
    data = { token: RED_CAP_TOKEN, content: 'participantList', format: 'json', instrument: survey_instrument, returnFormat: 'json' }

    begin
      response = HTTParty.post(RED_CAP_URL, body: data)
      if response.success? && response.parsed_response.present?
        participant_hash = response.parsed_response.select { |participant_data| participant_data['survey_link'] == survey_link }
        return participant_hash.first['response_status'] if participant_hash.present?
      end
    rescue HTTParty::Error, SocketError => e
      Rollbar.error("Error connecting to RedCap - #{e.message}")
    end
  end
end
