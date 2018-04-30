require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  it { expect(user.email).to match(/test\d+@email.com/) }
  it { expect(user.password).to eq('password') }
  it { expect(user.first_name).to eq('sushant') }
  it { expect(user.family_name).to eq('ahuja') }

  context 'validations' do
    it 'should have a flagship' do
      expect(user.valid?).to be true
      user.flagship = nil
      expect(user.valid?).to be false
    end

    it 'should have a study id' do
      expect(user.valid?).to be true
      user.study_id = nil
      expect(user.valid?).to be false
    end
    it 'should have a mandatory first name' do
      user.first_name = nil
      expect(user.save).to be false
      expect(user.errors[:first_name]).to include('can\'t be blank')
    end
    it 'should have a mandatory last name' do
      user.family_name = nil
      expect(user.save).to be false
      expect(user.errors[:family_name]).to include('can\'t be blank')
    end
    it 'should have a strong password' do
      user.password = 'pass'
      expect(user.save).to be false
      expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
    end
  end

  context '#create_consent_step' do
    it 'should have five steps' do
      expect(user.steps.count).to eq(5)
    end

    it 'should have step one' do
      expect(user.step_one.number).to eq(1)
      expect(user.step_one.accepted).to be false
      expect(user.step_one.questions).to be_blank
    end

    it 'should have step two' do
      expect(user.step_two.number).to eq(2)
      expect(user.step_two.accepted).to be false
      expect(user.step_two.questions).to be_blank
    end

    it 'should have step three' do
      expect(user.step_three.number).to eq(3)
      expect(user.step_three.accepted).to be false
      expect(user.step_three.questions).to be_blank
    end

    it 'should have step four' do
      expect(user.step_four.number).to eq(4)
      expect(user.step_four.accepted).to be false
      expect(user.step_four.questions).to be_blank
    end

    it 'should have step five' do
      expect(user.step_five.number).to eq(5)
      expect(user.step_five.accepted).to be false
      expect(user.step_five.questions).to be_blank
    end
  end

  describe '#step_one' do
    it 'should return step with number 1' do
      expect(user.step_one.number).to eq 1
    end
  end

  describe '#step_two' do
    it 'should return step with number 2' do
      expect(user.step_two.number).to eq 2
    end
  end

  describe '#step_three' do
    it 'should return step with number 3' do
      expect(user.step_three.number).to eq 3
    end
  end

  describe '#step_four' do
    it 'should return step with number 4' do
      expect(user.step_four.number).to eq 4
    end
  end

  describe '#step_five' do
    it 'should return step with number 5' do
      expect(user.step_five.number).to eq 5
    end
  end
end
