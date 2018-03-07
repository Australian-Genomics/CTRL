require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.create(:user)}

  it {expect(user.email).to eq('test1@email.com')}
  it {expect(user.password).to eq('password')}
end
