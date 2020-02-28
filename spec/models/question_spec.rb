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
    it 'should send back correct changes to questions' do
      question.update(answer: 'false')
      question.versions.last.update(created_at: 1.day.ago)
      question.update(answer: 'true')
      question.versions.last.update(created_at: 2.days.ago)
      question.update(answer: 'false')

      another_question = FactoryBot.create :question
      another_question.update(answer: 'true')
      another_question.versions.last.update(created_at: 1.day.ago)

      changes = Question.question_changes_for_last_day
      expect(changes.select { |s| s.item_id == question.id }.count).to eql 1
      expect(changes.select { |s| s.item_id == question.id }.first.changeset['answer']).to eql([nil, 'false'])
      expect(changes.select { |s| s.item_id == another_question.id }.count).to eql 1
      expect(changes.select { |s| s.item_id == another_question.id }.first.changeset['answer']).to eql([nil, 'true'])
    end
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
