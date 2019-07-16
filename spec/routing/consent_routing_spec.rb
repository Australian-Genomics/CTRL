require 'rails_helper'

RSpec.describe 'ConsentControllerRoutes', type: :routing do
  it 'routes /notification_consent to consent#notification_consent' do
    expect(get('notification_consent'))
      .to route_to(controller: 'consent',
                   action: 'notification_consent')
  end
end
