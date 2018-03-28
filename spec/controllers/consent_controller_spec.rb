require 'rails_helper'

RSpec.describe ConsentController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  describe 'step_one' do
    it 'should render the step one template' do
      get :step_one
      expect(user.current_consent_step).to eq('step_1')
    end

  end

end
