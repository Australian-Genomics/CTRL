require 'rails_helper'

RSpec.describe User, type: :mailer do
  let(:user) { FactoryBot.create(:user) }

  context '#send_first_survey_email' do
    it 'it should send an email with survey link in it' do
      email = UserMailer.send_first_survey_email(user)

      expect(email.to.first).to eq(user.email)
      expect(email.subject).to eq('Australian Genomics Patient Survey')
      expect(email.from.first).to eq('ctrl@australiangenomics.org.au')
      expect(user.survey_one_email_sent).to eq true
    end
  end

  context '#send_daily_consent_email_to_matilda' do
    it 'should send daily report to matilda about the changes in the consent preferences' do
      user.steps.second.questions.create
      user.steps.second.save
      user.steps.second.questions.first.update(answer: 1)
      email = UserMailer.send_daily_consent_email_to_matilda
      date_time_now_in_zone = Timezone['Australia/Melbourne'].time_with_offset(Time.now)
      @today_date = date_time_now_in_zone.try(:strftime, '%d/%m/%Y')

      expect(email.to.first).to eq('aghatesting@gmail.com')
      expect(email.subject).to eq("AGHA Participant Consent Preference Changes for #{@today_date}")
      expect(email.from.first).to eq('ctrl@australiangenomics.org.au')
    end
  end
end
