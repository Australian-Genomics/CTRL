require 'spec_helper'

RSpec.describe StudyUser, type: :model do
  let(:study_user) { FactoryBot.create(:study_user) }

  context 'validations' do
    it 'should have a participant ID' do
      expect(study_user.valid?).to be true
      study_user.participant_id = nil
      expect(study_user.valid?).to be false
    end

    it 'should have a participant ID matching the regex in study.participant_id_format' do
      regexp_str = '\Amy-participant-id-format\z'
      study_user.study.participant_id_format = regexp_str
      regexp = Regexp.new(regexp_str)

      expect do
        study_user.participant_id = regexp.random_example
        study_user.save!
      end.not_to raise_error(ActiveRecord::RecordInvalid)

      expect do
        study_user.participant_id = "#{regexp.random_example}-invalid"
        study_user.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not need a participant ID from REDCap when the email column is unset' do
      allow(study_user).to receive(:download_redcap_details)

      study_user.save!

      expect(study_user).not_to have_received(:download_redcap_details)
    end

    it 'should have a participant ID from REDCap when the email column is set' do
      UserColumnToRedcapFieldMapping.create(
        user_column: 'email',
        redcap_field: 'ctrl_email'
      )

      allow(study_user).to receive(:download_redcap_details).and_return([])

      expect do
        study_user.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
      expect(study_user.errors.messages[:participant_id]).to eq(['Participant ID not found'])
    end

    it 'should have a Participant ID whose email address matches REDCap' do
      UserColumnToRedcapFieldMapping.create(
        user_column: 'email',
        redcap_field: 'ctrl_email'
      )

      # Non-matching email
      allow(study_user).to receive(:download_redcap_details).and_return(
        [{ 'ctrl_email': "not-the-same-#{study_user.user.email}" }]
      )

      expect do
        study_user.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
      expect(study_user.errors.messages[:participant_id]).to eq(
        ['Participant ID does not match the provided email address']
      )

      # Matching email
      allow(study_user).to receive(:download_redcap_details).and_return(
        [{ 'ctrl_email' => study_user.user.email }]
      )

      expect do
        study_user.save!
      end.not_to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
