require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  it { expect(user.email).to match(/test\d+@email.com/) }
  it { expect(user.password).to eq('password') }
  it { expect(user.first_name).to eq('sushant') }
  it { expect(user.family_name).to eq('ahuja') }

  describe 'validate study_id' do
    let(:new_user) { User.new(user.attributes.merge(id: nil, study_id: study_id)) }

    before { new_user.valid? }

    context 'when study id not started with capital A' do
      let(:study_id) { 'B1523456' }

      it { expect(new_user).to be_a(User) }
      it { expect(new_user.errors).not_to be_empty }
      it { expect(new_user.errors[:study_id]).to eq(['Please check Study ID']) }
    end

    context 'when first number is not between 0 to 4 after capital A' do
      let(:study_id) { 'A5123456' }

      it { expect(new_user).to be_a(User) }
      it { expect(new_user.errors).not_to be_empty }
      it { expect(new_user.errors[:study_id]).to eq(['Please check Study ID']) }
    end

    context 'when third number is not between 2 to 4 after capital A' do
      let(:study_id) { 'A1563456' }

      it { expect(new_user).to be_a(User) }
      it { expect(new_user.errors).not_to be_empty }
      it { expect(new_user.errors[:study_id]).to eq(['Please check Study ID']) }
    end

    context 'when length of numbers after capital A is less than 7' do
      let(:study_id) { 'A154345' }

      it { expect(new_user).to be_a(User) }
      it { expect(new_user.errors).not_to be_empty }
      it { expect(new_user.errors[:study_id]).to eq(['Please check Study ID']) }
    end

    context 'when length of numbers after capital A is greater than 7' do
      let(:study_id) { 'A15434577' }

      it { expect(new_user).to be_a(User) }
      it { expect(new_user.errors).not_to be_empty }
      it { expect(new_user.errors[:study_id]).to eq(['Please check Study ID']) }
    end

    context 'when user have a valid Study id' do
      let(:study_id) { 'A1543457' }

      it { expect(new_user).to be_a(User) }
      it { expect(new_user.errors[:study_id]).to eq([]) }
    end
  end

  context 'validations' do
    it 'should have a mandatory preferred contact method' do
      expect(user.valid?).to be true
      user.preferred_contact_method = nil
      expect(user.valid?).to be false
    end
    it 'should have a mandatory flasghip' do
      expect(user.valid?).to be true
      user.flagship = nil
      expect(user.valid?).to be false
    end
    it 'should have a mandatory dob' do
      expect(user.valid?).to be true
      user.dob = nil
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
    it 'should have kin details when is parent is set to false' do
      user.is_parent = false
      expect(user.valid?).to be true
      user.kin_first_name = nil
      expect(user.valid?).to be false
    end
    it 'should have child details when is parent is set to true' do
      expect(user.valid?).to be true
      user.child_first_name = nil
      expect(user.valid?).to be false
    end

    describe 'Date of birth validations' do
      context 'when it is user dob' do
        context 'when user enters date of birth in future' do
          it 'returns error cannot enter the date from the future' do
            expect(user.valid?).to be true
            user.dob = Date.tomorrow.to_s
            expect(user.valid?).to be false
            expect(user.errors.full_messages).to match_array("Dob Can't be a date in the future")
          end
        end

        context 'when user enters date of birth in a wrong format' do
          it 'returns error invalid format' do
            expect(user.valid?).to be true
            user.dob = '12-13-2019'
            expect(user.valid?).to be false
            expect(user.errors.full_messages).to match_array('Dob Invalid format')
          end
        end
      end

      context 'when it is user child_dob' do
        context 'when user enters date of birth in future' do
          it 'returns error cannot enter the date from the future' do
            expect(user.valid?).to be true
            user.child_dob = Date.tomorrow.to_s
            expect(user.valid?).to be false
            expect(user.errors.full_messages).to match_array("Child dob Can't be a date in the future")
          end
        end

        context 'when user enters date of birth in a wrong format' do
          it 'returns error invalid format' do
            expect(user.valid?).to be true
            user.child_dob = '12-13-2019'
            expect(user.valid?).to be false
            expect(user.errors.full_messages).to match_array('Child dob Invalid format')
          end
        end
      end
    end
  end

  describe '#reset_password' do
    it 'should skip validations on update of some fields' do
      expect(user.valid?).to be true
      user.dob = nil
      expect(user.valid?).to be false
      expect(user.reset_password('Abcd#1234', 'Abcd#1234')).to be true
    end
  end
end
