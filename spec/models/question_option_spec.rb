require 'spec_helper'

RSpec.describe QuestionOption do
  let(:question_option) { build(:question_option) }

  subject { question_option }

  it { is_expected.to be_valid }

  describe 'associations' do
    it { should belong_to(:consent_question) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:value) }

    it {
      should validate_uniqueness_of(:value)
        .scoped_to(:consent_question_id)
    }

    describe 'parent_question_type' do
      context 'multiple choice' do
        subject do
          create(:consent_question, :multiple_choice).options.first
        end

        it { is_expected.to be_valid }
      end

      context 'other values' do
        subject do
          question = create(:consent_question, :checkbox)
          build(:question_option, consent_question: question)
        end

        it { is_expected.to_not be_valid }

        it {
          subject.valid?

          expect(subject.errors[:consent_question_id])
            .to match_array('incompatible question')
        }
      end
    end
  end
end
