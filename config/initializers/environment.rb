FALSE_VALUES = [
  nil,
  "",
  false, 0,
  "0", :"0",
  "f", :f,
  "F", :F,
  "false", :false,
  "FALSE", :FALSE,
  "off", :off,
  "OFF", :OFF,
].to_set.freeze

def to_boolean(v)
  !FALSE_VALUES.include?(v)
end

def fetch_env_var(key, default)
  value = ENV[key]
  value.nil? || value.empty? ? default : value
end

REDCAP_TOKEN = ENV['REDCAP_TOKEN']
REDCAP_API_URL = ENV['REDCAP_API_URL']
REDCAP_CONNECTION_ENABLED = to_boolean(
  fetch_env_var('REDCAP_CONNECTION_ENABLED', 'false'))
OTP_ENABLED = to_boolean(
  fetch_env_var('OTP_ENABLED', 'true'))

SENDER_EMAIL = fetch_env_var(
  'CTRL_ADMIN_EMAIL', 'australian.genomics@mcri.edu.au')
