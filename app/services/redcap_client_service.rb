class RedcapClientService
  attr_accessor :token, :api_url

  def initialize
    @token = ENV['RED_CAP_TOKEN']
    @api_url = ENV['RED_CAP_URL']
  end

  def call(data)
    begin
      response = HTTParty.post(api_url, body: body_attributes(data))
      response.success? && response['count'] > 0
    rescue HTTParty::Error, SocketError => e
      Rollbar.error("Error connecting to RedCap - #{e.message}")
    end
  end

  private

  def body_attributes(data)
    { token: token, content: 'record',
      format: 'json', type: 'flat',
      data: data
    }
  end
end