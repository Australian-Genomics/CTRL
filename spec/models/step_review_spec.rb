require 'spec_helper'

RSpec.describe StepReview do
  let(:step_review) { build(:step_review) }

  subject { step_review }

  it { is_expected.to be_valid }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:consent_step) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:consent_step_id) }

    it {
      should validate_uniqueness_of(:user_id)
        .scoped_to(:consent_step_id)
    }
  end
end
