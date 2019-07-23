require 'rails_helper'

RSpec.describe Step, type: :model do
  let(:user) { FactoryBot.create :user }
  let(:step_two) { FactoryBot.create :step, number: 2 }
  let(:step_three) { FactoryBot.create :step, number: 3 }
  let(:step_four) { FactoryBot.create :step, number: 4 }
  let(:step_five) { FactoryBot.create :step, number: 5 }

  describe '#build_question_for_step' do
    it 'should build 11 questions for step_two' do
      expect(step_two.questions).to receive(:build).exactly(11).times
      expect(step_two.build_question_for_step(user.id)).to eq 1..11
    end

    it 'should build 3 questions for step_three' do
      expect(step_three.questions).to receive(:build).exactly(4).times
      expect(step_three.build_question_for_step(user.id)).to eq 12..15
    end

    it 'should build 6 questions for step_four' do
      expect(step_four.questions).to receive(:build).exactly(6).times
      expect(step_four.build_question_for_step(user.id)).to eq 16..21
    end

    it 'should build 11 questions for step_five' do
      expect(step_five.questions).to receive(:build).exactly(13).times
      expect(step_five.build_question_for_step(user.id)).to eq 22..34
    end
  end
end
