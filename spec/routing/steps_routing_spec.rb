require 'rails_helper'

RSpec.describe 'routes for Steps', type: :routing do
  it 'routes /steps/:id?registration_step_two=true to steps#update' do
    expect(patch('/steps/1?registration_step_two=true'))
      .to route_to(controller: 'steps',
                   action: 'update',
                   id: '1',
                   registration_step_two: 'true')
  end
end
