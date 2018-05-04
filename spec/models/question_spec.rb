require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { FactoryBot.create :question }

  describe '#default_answer_to_be_not_sure' do
    it 'should have default answer to be not sure' do
      expect(question.answer).to eq('not_sure')
    end
  end
end
