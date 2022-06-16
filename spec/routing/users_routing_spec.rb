require 'spec_helper'

RSpec.describe 'routes for users', type: :routing do
  it 'routes /users/profile to users#show' do
    expect(get('/users/profile'))
      .to route_to('users#show', id: 'profile')
  end

  it 'routes /users/edit_profile to users#edit' do
    expect(get('/users/profile/edit'))
      .to route_to('users#edit', id: 'profile')
  end

  it 'routes /users/profile/update to users#update' do
    expect(patch('/users/profile/update'))
      .to route_to('users#update')
  end
end
