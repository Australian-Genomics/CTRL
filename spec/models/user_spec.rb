require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  it { expect(user.email).to match(/test\d+@email.com/) }
  it { expect(user.password).to eq('password') }
  it { expect(user.first_name).to eq('sushant') }
  it { expect(user.family_name).to eq('ahuja') }

  context 'update_consent_signed_date' do
    it 'should update the consign signd date' do
      expect(user.red_cap_date_consent_signed).to be_blank
      User.update_consent_signed_date({ 'ethic_cons_sign_date' => '01/01/2010', 'red_cap_date_of_result_disclosure' => '02/02/2012' }, user)
      expect(user.red_cap_date_consent_signed).to eql(Date.parse('01/01/2010'))
    end

    it 'should not update the consign signd date is not there' do
      expect(user.red_cap_date_consent_signed).to be_blank
      User.update_consent_signed_date({ 'red_cap_date_of_result_disclosure' => '01/01/2010' }, user)
      expect(user.red_cap_date_consent_signed).to be_blank
    end

    it 'should not update the consign signd date if data is not there' do
      expect(user.red_cap_date_consent_signed).to be_blank
      User.update_consent_signed_date(nil, user)
      expect(user.red_cap_date_consent_signed).to be_blank
    end
  end

  context 'red_cap_date_of_result_disclosure' do
    it 'should update the reuslt date' do
      expect(user.red_cap_date_of_result_disclosure).to be_blank
      User.update_result_disclosure_date({ 'ethic_cons_sign_date' => '01/01/2010', 'red_cap_date_of_result_disclosure' => '02/02/2012' }, user)
      expect(user.red_cap_date_of_result_disclosure).to eql(Date.parse('02/02/2012'))
    end

    it 'should not update the result date is not there' do
      expect(user.red_cap_date_of_result_disclosure).to be_blank
      User.update_result_disclosure_date({ 'ethic_cons_sign_date' => '01/01/2010' }, user)
      expect(user.red_cap_date_of_result_disclosure).to be_blank
    end

    it 'should not update the result date if data is not there' do
      expect(user.red_cap_date_consent_signed).to be_blank
      User.update_result_disclosure_date(nil, user)
      expect(user.red_cap_date_consent_signed).to be_blank
    end
  end

  context 'update_dates_from_redcap' do
    it 'should get the data from redcap and update the dates if user is missing both dates' do
      dates_mock = double('dates')
      expect(RedCapManager).to receive(:get_consent_and_result_dates).with(user.study_id).and_return(dates_mock)
      expect(User).to receive(:update_consent_signed_date).with(dates_mock, user)
      User.update_dates_from_redcap
    end

    it 'should not get the data from redcap if the consent date is not nil' do
      user.update(red_cap_date_consent_signed: Date.today)
      expect(RedCapManager).to_not receive(:get_consent_and_result_dates)
      expect(User).to_not receive(:update_consent_signed_date)
      User.update_dates_from_redcap
    end
  end

  context 'update_survey_one_link_from_redcap' do
    it 'should update the link from redcap' do
      survey_link = 'http://randomlink.com/23423'
      expect(user.red_cap_survey_one_link).to be_blank
      expect(RedCapManager).to receive(:get_survey_one_link).with(user.study_id).and_return(survey_link)
      User.update_survey_one_link_from_redcap
      expect(User.find(user.id).red_cap_survey_one_link).to eql(survey_link)
    end

    it 'should not update the link from redcap if it was already present' do
      user.update(red_cap_survey_one_link: 'http://randomlink.com/23423')
      expect(RedCapManager).to_not receive(:get_survey_one_link)
      User.update_survey_one_link_from_redcap
      expect(user.red_cap_survey_one_link).to_not be_blank
    end
  end

  context 'update_survey_one_link_from_redcap' do
    it 'should update the link from redcap' do
      survey_code = 'SDFATE'
      expect(user.red_cap_survey_one_link).to be_blank
      expect(RedCapManager).to receive(:get_survey_one_return_code).with(user.study_id).and_return(survey_code)
      User.update_survey_one_code_from_redcap
      expect(User.find(user.id).red_cap_survey_one_return_code).to eql(survey_code)
    end

    it 'should not update the link from redcap if it was already present' do
      user.update(red_cap_survey_one_return_code: 'SFGE')
      expect(RedCapManager).to_not receive(:get_survey_one_return_code)
      User.update_survey_one_code_from_redcap
      expect(user.red_cap_survey_one_return_code).to_not be_blank
    end
  end

  context 'update_survey_one_code_from_redcap' do
    it 'should update the link from redcap' do
      survey_code = 'SDFATE'
      expect(user.red_cap_survey_one_return_code).to be_blank
      expect(RedCapManager).to receive(:get_survey_one_return_code).with(user.study_id).and_return(survey_code)
      User.update_survey_one_code_from_redcap
      expect(User.find(user.id).red_cap_survey_one_return_code).to eql(survey_code)
    end

    it 'should not update the link from redcap if it was already present' do
      user.update(red_cap_survey_one_return_code: 'SFGE')
      expect(RedCapManager).to_not receive(:get_survey_one_return_code)
      User.update_survey_one_code_from_redcap
      expect(user.red_cap_survey_one_return_code).to_not be_blank
    end
  end

  context 'update_survey_one_status_from_redcap' do
    it 'should update the status from redcap if survey link is present' do
      survey_status = '1'
      user.update(red_cap_survey_one_link: 'http://randomlink.com/23423')
      expect(user.red_cap_survey_one_status).to be_blank
      expect(RedCapManager).to receive(:get_survey_one_status).with(user.red_cap_survey_one_link).and_return(survey_status)
      User.update_survey_one_status_from_redcap
      expect(User.find(user.id).red_cap_survey_one_status).to eql(survey_status.to_i)
    end

    it 'should not update the status from redcap if the survey link is not present' do
      user.update(red_cap_survey_one_link: nil)
      expect(RedCapManager).to_not receive(:get_survey_one_status)
      User.update_survey_one_status_from_redcap
      expect(user.red_cap_survey_one_status).to be_blank
    end
  end

  context 'send_survey_one_emails' do
    it 'should send an email if the date of consent is greater than 1 week and the email hasn\'t been set yet' do
      user.update(red_cap_date_consent_signed: 1.week.ago)
      user.update(survey_one_email_sent: false)
      user.update(red_cap_survey_one_link: 'http://somelink.com/234234')

      delay_mail_mock = double('mail mock')
      expect(UserMailer).to receive(:delay).and_return(delay_mail_mock)
      expect(delay_mail_mock).to receive(:send_first_survey_email).with(user)
      User.send_survey_one_emails
    end

    it 'should not send an email if the date of consent is less than 1 week and the email hasn\'t been set yet' do
      user.update(red_cap_date_consent_signed: 6.days.ago)
      user.update(survey_one_email_sent: false)
      user.update(red_cap_survey_one_link: 'http://somelink.com/234234')
      expect(UserMailer).to_not receive(:delay)
      User.send_survey_one_emails
    end

    it 'should not send an email if the email has already been sent' do
      user.update(red_cap_date_consent_signed: 1.week.ago)
      user.update(survey_one_email_sent: true)
      user.update(red_cap_survey_one_link: 'http://somelink.com/234234')
      expect(UserMailer).to_not receive(:delay)
      User.send_survey_one_emails
    end

    it 'should not send an email if the survey link is missing' do
      user.update(red_cap_date_consent_signed: 1.week.ago)
      user.update(survey_one_email_sent: false)
      user.update(red_cap_survey_one_link: nil)
      expect(UserMailer).to_not receive(:delay)
      User.send_survey_one_emails
    end
  end

  context 'send_survey_emails' do
    it 'should update redcap and send emails' do
      expect(User).to receive(:update_dates_from_redcap)
      expect(User).to receive(:update_survey_one_link_from_redcap)
      expect(User).to receive(:update_survey_one_code_from_redcap)
      expect(User).to receive(:update_survey_one_status_from_redcap)
      expect(User).to receive(:send_survey_one_emails)
      User.send_survey_emails
    end
  end

  context 'genetic counsellor' do
    it 'should return Ella Wilkins for A0134XXX' do
      user.update(study_id: 'A0134564')
      gc = user.genetic_counsellor
      expect(gc[:name]).to eql('Ella Wilkins')
      expect(gc[:site]).to eql('RCH')
      expect(gc[:phone]).to eql('03 9936 6333')
      expect(gc[:email]).to eql('ella.wilkins@vcgs.org.au')
    end

    it 'should return Lindsay Fowles for A1534XXX' do
      user.update(study_id: 'A1534564')
      gc = user.genetic_counsellor
      expect(gc[:name]).to eql('Lindsay Fowles')
      expect(gc[:site]).to eql('RBWH')
      expect(gc[:phone]).to eql('07 3646 1686 (M,T,W,F) 07 3646 0254 (Th)')
      expect(gc[:email]).to eql('Lindsay.Fowles@health.qld.gov.au')
    end

    context 'for Gayathri Parasivam' do
      it 'should return A0434XXX' do
        user.update(study_id: 'A0434564')
        gc = user.genetic_counsellor
        expect(gc[:name]).to eql('Gayathri Parasivam')
        expect(gc[:site]).to eql('SCHN')
        expect(gc[:phone]).to eql('02 9845 1225')
        expect(gc[:email]).to eql('gayathri.parasivam@health.nsw.gov.au')
      end

      it 'should return A1434XXX' do
        user.update(study_id: 'A1434564')
        gc = user.genetic_counsellor
        expect(gc[:name]).to eql('Gayathri Parasivam')
        expect(gc[:site]).to eql('SCHN')
        expect(gc[:phone]).to eql('02 9845 1225')
        expect(gc[:email]).to eql('gayathri.parasivam@health.nsw.gov.au')
      end
    end

    context 'Kirsten Boggs' do
      it 'should return for A0132XXX' do
        user.update(study_id: 'A0132564')
        gc = user.genetic_counsellor
        expect(gc[:name]).to eql('Kirsten Boggs')
        expect(gc[:site]).to eql('SCHN')
        expect(gc[:phone]).to eql('02 9382 5616 (Randwick) 02 9845 3273 (Westmead)')
        expect(gc[:email]).to eql('kirsten.boggs@health.nsw.gov.au')
      end

      it 'should return for A0432XXX' do
        user.update(study_id: 'A0432564')
        gc = user.genetic_counsellor
        expect(gc[:name]).to eql('Kirsten Boggs')
        expect(gc[:site]).to eql('SCHN')
        expect(gc[:phone]).to eql('02 9382 5616 (Randwick) 02 9845 3273 (Westmead)')
        expect(gc[:email]).to eql('kirsten.boggs@health.nsw.gov.au')
      end

      it 'should return for A1432XXX' do
        user.update(study_id: 'A1432564')
        gc = user.genetic_counsellor
        expect(gc[:name]).to eql('Kirsten Boggs')
        expect(gc[:site]).to eql('SCHN')
        expect(gc[:phone]).to eql('02 9382 5616 (Randwick) 02 9845 3273 (Westmead)')
        expect(gc[:email]).to eql('kirsten.boggs@health.nsw.gov.au')
      end

      it 'should return for A1532XXX' do
        user.update(study_id: 'A1532564')
        gc = user.genetic_counsellor
        expect(gc[:name]).to eql('Kirsten Boggs')
        expect(gc[:site]).to eql('SCHN')
        expect(gc[:phone]).to eql('02 9382 5616 (Randwick) 02 9845 3273 (Westmead)')
        expect(gc[:email]).to eql('kirsten.boggs@health.nsw.gov.au')
      end
    end

    it 'should return blank if not matched' do
      user.update(study_id: 'A999')
      gc = user.genetic_counsellor
      expect(gc[:name]).to eql('')
      expect(gc[:site]).to eql('')
      expect(gc[:phone]).to eql('')
      expect(gc[:email]).to eql('australian.genomics@mcri.edu.au')
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
  end

  describe '#reset_password' do
    it 'should skip validations on update of some fields' do
      expect(user.valid?).to be true
      user.dob = nil
      expect(user.valid?).to be false
      expect(user.reset_password('Abcd#1234', 'Abcd#1234')).to be true
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
