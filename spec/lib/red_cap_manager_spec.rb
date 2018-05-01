require 'rails_helper'

describe RedCapManager do
  context 'get dates' do
    it 'should get the record date consent signed "ethic_cons_sign_date" and "cmdt_resul_dte"' do
      record_id = 'A0120001'
      data = {:token => "69712346139C3ED3BE4795341852A598", :content => "record", :format => "json", :type => "flat", "records[0]" => record_id, :returnFormat => "json"}
      red_cap_url = 'https://redcap.mcri.edu.au/api/'

      response_mock = double('redcap response')
      parsed_response_mock = double('parsed response', first: {'ethic_cons_sign_date' => '2017-06-28', 'cmdt_resul_dte' => '2018-01-10'})

      expect(HTTParty).to receive(:post).with(red_cap_url, :body => data).and_return(response_mock)
      expect(response_mock).to receive(:success?).and_return(true)
      expect(response_mock).to receive(:parsed_response).and_return(parsed_response_mock).twice

      dates_hash = RedCapManager.get_consent_and_result_dates(record_id)
      expect(dates_hash['ethic_cons_sign_date']).to eql('2017-06-28')
      expect(dates_hash['cmdt_resul_dte']).to eql('2018-01-10')
    end
  end

  it 'should get the record date consent signed (ethic_cons_sign_date)' do
    record_id = 'A0120001'
    data = {:token => "69712346139C3ED3BE4795341852A598", :content => "record", :format => "json", :type => "flat", "records[0]" => record_id, :returnFormat => "json"}
    red_cap_url = 'https://redcap.mcri.edu.au/api/'

    expect(HTTParty).to receive(:post).with(red_cap_url, :body => data).and_raise(HTTParty::Error)
    expect(Rollbar).to receive(:error).with('Error connecting to RedCap - HTTParty::Error')

    dates_hash = RedCapManager.get_consent_and_result_dates(record_id)
    expect(dates_hash).to be_blank
  end
end
