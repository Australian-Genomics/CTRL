require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { FactoryBot.create :question }
  let(:default_answer) { true }

  describe '#default_answer_to_be_not_sure' do
    it 'should have default answer to be not sure' do
      question.update(answer: 2)
      expect(question.answer).to eq('not_sure')
    end
  end

  describe 'get_question_changes_for_last_day' do
    let(:questions) { Question.question_changes_for_last_day }

    before do
      question.versions.last.update(created_at: 1.day.ago)
    end

    it { expect(questions.to_a.size).to eq(1) }
    it { expect(questions.first).to eq(question) }
  end

  describe '.check_box_checked?' do
    context 'when answer exists in the database' do
      before { question.update(answer: answer) }
      context 'and when answer is true' do
        let(:answer) { 1 }
        it 'returns true' do
          expect(question.check_box_checked?(default_answer)).to be_truthy
        end
      end

      context 'and when answer is false' do
        let(:answer) { 0 }
        it 'returns false' do
          expect(question.check_box_checked?(default_answer)).to be_falsey
        end
      end
    end

    context 'when answer doesnot exists in the database' do
      it 'returns the default_answer' do
        expect(question.check_box_checked?(default_answer)).to be_truthy
      end
    end
  end

  describe '.radio_button_checked?' do
    context 'when answer exists in the database' do
      before { question.update(answer: answer) }
      context 'when answer is not sure' do
        let(:answer) { 2 }
        it 'returns not sure' do
          expect(question.radio_button_checked?(default_answer)).to eq('not_sure')
        end
      end

      context 'when answer is true' do
        let(:answer) { 1 }
        it 'returns true' do
          expect(question.radio_button_checked?(default_answer)).to be_truthy
        end
      end

      context 'when answer is false' do
        let(:answer) { 0 }
        it 'returns false' do
          expect(question.radio_button_checked?(default_answer)).to be_falsey
        end
      end
    end

    context 'when answer does not exists in the database' do
      it 'returns the default answer' do
        expect(question.radio_button_checked?(default_answer)).to be_truthy
      end
    end
  end

  describe '#answer_value' do
    before { question.update(answer: 'true') }
    it { expect(question.answer_value).to eq(1) }
  end
end
