require 'rails_helper'

RSpec.describe Step, type: :model do
  include ActiveJob::TestHelper

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

  describe '#user_study_id delegate' do
    before { step_two.update(user_id: user.id) }

    it { expect(step_two.user_study_id).to eq('A0134001') }
  end

  describe '#upload_with_redcap' do
    let(:step) { step_two }
    before { step.upload_with_redcap(step_params) }

    context 'when step number is other than four and five' do
      let(:step_params) { { accepted: true } }
      let(:step) { step_two }

      it { expect(step.accepted).to eq(true) }
    end

    context 'when step number is four' do
      let(:step_params) { { accepted: true, questions_attributes: { '0' => { answer: 'true' }, '1' => { answer: 'false' } } } }
      let(:step) { step_four }

      it { expect(step.accepted).to eq(true) }
      it { expect(enqueued_jobs.size).to eq(1) }
    end

    context 'when step number is five' do
      let(:step_params) { { accepted: true, questions_attributes: { '0' => { answer: 'true' }, '1' => { answer: 'false' } } } }
      let(:step) { step_five }

      it { expect(step.accepted).to eq(true) }
      it { expect(enqueued_jobs.size).to eq(1) }
    end
  end
end
