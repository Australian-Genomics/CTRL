require 'spec_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  it { expect(user.email).to match(/test\d+@email.com/) }
  it { expect(user.password).to eq('password') }
  it { expect(user.first_name).to eq('sushant') }
  it { expect(user.family_name).to eq('ahuja') }

  context 'validations' do
    it 'should have a mandatory preferred contact method' do
      expect(user.valid?).to be true
      user.preferred_contact_method = nil
      expect(user.valid?).to be false
    end
    it 'should have a mandatory dob' do
      expect(user.valid?).to be true
      user.dob = nil
      expect(user.valid?).to be false
    end
    it 'should have a participant ID' do
      expect(user.valid?).to be true
      user.participant_id = nil
      expect(user.valid?).to be false
    end
    it 'should have a participant ID matching the regexes in ParticipantIdFormat' do
      regexp_str = '\Amy-participant-id-format\z'
      regexp = Regexp.new(regexp_str)

      ParticipantIdFormat.create(participant_id_format: regexp_str)

      expect {
        FactoryBot.create(:user, participant_id: regexp.random_example)
      }.not_to raise_error(ActiveRecord::RecordInvalid)

      expect {
        FactoryBot.create(:user, participant_id: regexp.random_example + '-invalid')
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
    it 'should not need a participant ID from REDCap when the email column is unset' do
      user = FactoryBot.build(:user)

      allow(user).to receive(:download_redcap_details)

      user.save!

      expect(user).not_to have_received(:download_redcap_details)
    end
    it 'should have a participant ID from REDCap when the email column is set' do
      UserColumnToRedcapFieldMapping.create(
        user_column: 'email',
        redcap_field: 'ctrl_email')

      user = FactoryBot.build(:user)

      allow(user).to receive(:download_redcap_details).and_return([])

      expect {
        user.save!
      }.to raise_error(ActiveRecord::RecordInvalid)
      expect(user.errors.messages[:participant_id]).to eq(['Participant ID not found'])
    end
    it 'should have a Participant ID whose email address matches REDCap' do
      UserColumnToRedcapFieldMapping.create(
        user_column: 'email',
        redcap_field: 'ctrl_email')

      user = FactoryBot.build(:user)

      # Non-matching email
      allow(user).to receive(:download_redcap_details).and_return(
        [{'ctrl_email': 'not-the-same-' + user.email}]
      )

      expect {
        user.save!
      }.to raise_error(ActiveRecord::RecordInvalid)
      expect(user.errors.messages[:participant_id]).to eq(
        ['Participant ID does not match the provided email address']
      )

      # Matching email
      allow(user).to receive(:download_redcap_details).and_return(
        [{'ctrl_email' => user.email}]
      )

      expect {
        user.save!
      }.not_to raise_error(ActiveRecord::RecordInvalid)
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
    it 'should have an optional kin_email field when NEXT_OF_KIN_NEEDED_TO_REGISTER=false upon create' do
      sc = SurveyConfig.find_or_create_by(name: NEXT_OF_KIN_NEEDED_TO_REGISTER)
      sc.value = "false"
      sc.save!

      user = FactoryBot.create(:user, kin_email: nil)

      expect(user.valid?).to be true
    end
    it 'should have a mandatory kin_email field when NEXT_OF_KIN_NEEDED_TO_REGISTER=true upon create' do
      sc = SurveyConfig.find_or_create_by(name: NEXT_OF_KIN_NEEDED_TO_REGISTER)
      sc.value = "true"
      sc.save!

      expect {
        FactoryBot.create(:user, is_parent: false, kin_email: nil)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
    it 'should have a mandatory kin_email field when is_parent=false upon update' do
      user = FactoryBot.create(:user, is_parent: false, kin_email: nil)
      user.kin_email = 'different email but still not valid'

      expect {
        user.save!
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
    it 'should have an optional kin_email field when is_parent=false upon create' do
      user = FactoryBot.build(:user, is_parent: false, kin_email: nil)
      expect(user.valid?).to be true
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
