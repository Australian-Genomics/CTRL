require 'spec_helper'

RSpec.describe QuestionOption do
  let(:question_option) do
    create(:question_option, :with_consent_question)
  end

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

      context 'multiple checkboxes' do
        subject do
          create(:consent_question, :multiple_checkboxes).options.first
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

    describe 'associated_question_still_valid?' do
      context 'multiple choice' do
        let(:consent_question) do
          create(:consent_question, :multiple_choice, default_answer: 'yes')
        end

        it 'raises an exception when deleting an option used as a default' do
          answers = consent_question.answers.map(&:answer)
          expect do
            consent_question
              .question_options
              .reject { |qo| answers.include?(qo.value) }
              .select { |qo| qo.value == consent_question.default_answer }
              .each(&:destroy)
          end.to raise_error(UncaughtThrowError)
        end

        it 'raises an exception when deleting an option used as an answer' do
          consent_question.answers.build(answer: 'no')
          answers = consent_question.answers.map(&:answer)
          expect do
            consent_question
              .question_options
              .select { |qo| answers.include?(qo.value) }
              .reject { |qo| qo.value == consent_question.default_answer }
              .each(&:destroy)
          end.to raise_error(UncaughtThrowError)
        end
      end

      context 'multiple checkboxes' do
        let(:consent_question) do
          create(:consent_question, :multiple_choice, default_answer: 'yes')
        end

        it 'raises an exception when deleting an option used as a default' do
          answers = consent_question.answers.map(&:answer)
          expect do
            consent_question
              .question_options
              .reject { |qo| answers.include?(qo.value) }
              .select { |qo| qo.value == consent_question.default_answer }
              .each(&:destroy)
          end.to raise_error(UncaughtThrowError)
        end

        it 'raises an exception when deleting an option used as an answer' do
          consent_question.answers.build(answer: 'no')
          answers = consent_question.answers.map(&:answer)
          expect do
            consent_question
              .question_options
              .select { |qo| answers.include?(qo.value) }
              .reject { |qo| qo.value == consent_question.default_answer }
              .each(&:destroy)
          end.to raise_error(UncaughtThrowError)
        end
      end
    end
  end
end
