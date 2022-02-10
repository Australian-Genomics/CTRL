require 'spec_helper'

RSpec.describe QuestionAnswer do
  let(:question_answer) { build(:question_answer) }

  subject { question_answer }

  it { is_expected.to be_valid }

  describe 'associations' do
    it { should belong_to(:consent_question) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:answer) }

    it {
      should validate_uniqueness_of(:user_id)
        .scoped_to(:consent_question_id)
    }
  end
end
