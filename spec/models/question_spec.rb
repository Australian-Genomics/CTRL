require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { FactoryBot.create :question }

  describe '#default_answer_to_be_not_sure' do
    it 'should have default answer to be not sure' do
      expect(question.answer).to eq('not_sure')
    end
  end

  describe 'get_question_changes_for_last_day' do
    it 'should send back correct changes to questions' do
      question.update(answer: 'false')
      question.update(answer: 'true')
      question.versions.last.update(created_at: 2.days.ago)

      another_question = FactoryBot.create :question
      another_question.update(answer: 'true')

      changes = Question.question_changes_for_last_day
      expect(changes.select { |s| s.item_id == question.id }.count).to eql 1
      expect(changes.select { |s| s.item_id == question.id }.first.changeset['answer']).to eql(%w[not_sure false])
      expect(changes.select { |s| s.item_id == another_question.id }.count).to eql 1
      expect(changes.select { |s| s.item_id == another_question.id }.first.changeset['answer']).to eql(%w[not_sure true])
    end
  end
end
