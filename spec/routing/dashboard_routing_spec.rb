require 'spec_helper'

RSpec.describe 'routes for dashboard', type: :routing do
  it 'routes /news_and_info to dashboard#news_and_info' do
    expect(get('/news_and_info'))
      .to route_to('dashboard#news_and_info')
  end

  it 'routes /contact_us to dashboard#contact_us' do
    expect(get('/contact_us'))
      .to route_to('dashboard#contact_us')
  end

  it 'routes /message_sent to dashboard#message_sent' do
    expect(get('/message_sent'))
      .to route_to('dashboard#message_sent')
  end

  it 'routes /send_message to dashboard#send_message' do
    expect(post('/send_message')).to route_to('dashboard#send_message')
  end
end
