require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  it { expect(user.email).to eq('test1@email.com') }
  it { expect(user.password).to eq('password') }
  it { expect(user.first_name).to eq('sushant') }
  it { expect(user.family_name).to eq('ahuja') }

  it 'should have a flagship' do
    expect(user.save).to be true
  end

  it 'should have a study id' do
    expect(user.save).to be true
  end

  context 'validations' do
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

  context 'save_step' do
    it 'should have five steps' do
      expect(user.steps.count).to eq(5)
    end
    it 'should have a step one' do
      expect(user.steps[0].number).to eq(1)
      expect(user.steps[0].accepted).to be false
      expect(user.steps[0].questions).to be_blank
    end
    it 'should have a step two' do
      expect(user.steps[1].number).to eq(2)
      expect(user.steps[1].accepted).to be false
      expect(user.steps[1].questions.count).to eq(11)
      expect(user.steps[1].questions[0].number).to eq(1)
      expect(user.steps[1].questions[1].number).to eq(2)
      expect(user.steps[1].questions[2].number).to eq(3)
      expect(user.steps[1].questions[3].number).to eq(4)
      expect(user.steps[1].questions[4].number).to eq(5)
      expect(user.steps[1].questions[5].number).to eq(6)
      expect(user.steps[1].questions[6].number).to eq(7)
      expect(user.steps[1].questions[7].number).to eq(8)
      expect(user.steps[1].questions[8].number).to eq(9)
      expect(user.steps[1].questions[9].number).to eq(10)
      expect(user.steps[1].questions[10].number).to eq(11)
      expect(user.steps[1].questions[0].answer).to be nil
      expect(user.steps[1].questions[1].answer).to be nil
      expect(user.steps[1].questions[2].answer).to be nil
      expect(user.steps[1].questions[3].answer).to be nil
      expect(user.steps[1].questions[4].answer).to be nil
      expect(user.steps[1].questions[5].answer).to be nil
      expect(user.steps[1].questions[6].answer).to be nil
      expect(user.steps[1].questions[7].answer).to be nil
      expect(user.steps[1].questions[8].answer).to be nil
      expect(user.steps[1].questions[9].answer).to be nil
      expect(user.steps[1].questions[10].answer).to be nil
    end
    it 'should have a step three' do
      expect(user.steps[2].number).to eq(3)
      expect(user.steps[2].accepted).to be false
      expect(user.steps[2].questions.count).to eq(3)
      expect(user.steps[2].questions[0].number).to eq(1)
      expect(user.steps[2].questions[1].number).to eq(2)
      expect(user.steps[2].questions[2].number).to eq(3)
      expect(user.steps[2].questions[0].answer).to be nil
      expect(user.steps[2].questions[1].answer).to be nil
      expect(user.steps[2].questions[2].answer).to be nil
    end
    it 'should have a step four' do
      expect(user.steps[3].number).to eq(4)
      expect(user.steps[3].accepted).to be false
      expect(user.steps[3].questions.count).to eq(6)
      expect(user.steps[3].questions[0].number).to eq(1)
      expect(user.steps[3].questions[1].number).to eq(2)
      expect(user.steps[3].questions[2].number).to eq(3)
      expect(user.steps[3].questions[3].number).to eq(4)
      expect(user.steps[3].questions[4].number).to eq(5)
      expect(user.steps[3].questions[5].number).to eq(6)
      expect(user.steps[3].questions[0].answer).to be nil
      expect(user.steps[3].questions[1].answer).to be nil
      expect(user.steps[3].questions[2].answer).to be nil
      expect(user.steps[3].questions[3].answer).to be nil
      expect(user.steps[3].questions[4].answer).to be nil
      expect(user.steps[3].questions[5].answer).to be nil
    end
    it 'should have a step five' do
      expect(user.steps[4].number).to eq(5)
      expect(user.steps[4].accepted).to be false
      expect(user.steps[4].questions.count).to eq(11)
      expect(user.steps[4].questions[0].number).to eq(1)
      expect(user.steps[4].questions[1].number).to eq(2)
      expect(user.steps[4].questions[2].number).to eq(3)
      expect(user.steps[4].questions[3].number).to eq(4)
      expect(user.steps[4].questions[4].number).to eq(5)
      expect(user.steps[4].questions[5].number).to eq(6)
      expect(user.steps[4].questions[6].number).to eq(7)
      expect(user.steps[4].questions[7].number).to eq(8)
      expect(user.steps[4].questions[8].number).to eq(9)
      expect(user.steps[4].questions[9].number).to eq(10)
      expect(user.steps[4].questions[10].number).to eq(11)
      expect(user.steps[4].questions[0].answer).to be nil
      expect(user.steps[4].questions[1].answer).to be nil
      expect(user.steps[4].questions[2].answer).to be nil
      expect(user.steps[4].questions[3].answer).to be nil
      expect(user.steps[4].questions[4].answer).to be nil
      expect(user.steps[4].questions[5].answer).to be nil
      expect(user.steps[4].questions[6].answer).to be nil
      expect(user.steps[4].questions[7].answer).to be nil
      expect(user.steps[4].questions[8].answer).to be nil
      expect(user.steps[4].questions[9].answer).to be nil
      expect(user.steps[4].questions[10].answer).to be nil
    end
  end
end
