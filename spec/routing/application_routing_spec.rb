require 'spec_helper'

RSpec.describe 'routes for application', type: :routing do
  it 'routes /application/logo.png' do
    expect(get('/application/logo.png'))
      .to route_to('application#logo')
  end
end
