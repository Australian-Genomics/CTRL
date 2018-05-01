class RedCapManager
  def self.get_consent_and_result_dates(participant_id)
    data = { :token => '***REMOVED***', :content => 'record', :format => 'json', :type => 'flat', 'records[0]' => participant_id, :returnFormat => 'json' }

    begin
      response = HTTParty.post('https://redcap.mcri.edu.au/api/', body: data)
      if response.success? && response.parsed_response.present? && response.parsed_response.first.present?
        participant_data = response.parsed_response.first
        return participant_data.slice('ethic_cons_sign_date', 'cmdt_resul_dte')
      end
    rescue HTTParty::Error, SocketError => e
      Rollbar.error("Error connecting to RedCap - #{e.message}")
    end
  end

  def self.get_survey_one_link(participant_id)
    data = { :token => '***REMOVED***', :content => 'surveyLink', :format => 'json', :instrument => 'rare_disease_patient_survey', 'record' => participant_id,
             :returnFormat => 'json' }

    begin
      response = HTTParty.post('https://redcap.mcri.edu.au/api/', body: data)
      return response.parsed_response if response.success? && response.parsed_response.present?
    rescue HTTParty::Error, SocketError => e
      Rollbar.error("Error connecting to RedCap - #{e.message}")
    end
  end
end
