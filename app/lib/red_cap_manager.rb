class RedCapManager
  def self.get_consent_and_result_dates(participant_id)
    data = { :token => "69712346139C3ED3BE4795341852A598", :content => "record", :format => "json", :type => "flat", "records[0]" => participant_id, :returnFormat => "json" }

    begin
      response = HTTParty.post('https://redcap.mcri.edu.au/api/', :body => data)
      if response.success? && response.parsed_response.present?
        participant_data = response.parsed_response.first
        return participant_data.slice('ethic_cons_sign_date', 'cmdt_resul_dte')
      end
    rescue HTTParty::Error, SocketError => e
      Rollbar.error("Error connecting to RedCap - #{e.message}")
    end
  end
end
