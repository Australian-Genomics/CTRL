require 'rails_helper'

RSpec.describe ContactUs, type: :mailer do
  let(:user) { FactoryBot.create(:user) }
  let(:message) { 'Hello' }

  before(:context) do
    ENV['CTRL_ADMIN_EMAIL'] = 'australian.genomics@mcri.edu.au'
  end

  context '#send_contact_us_email' do
    it 'it should send message to admin' do
      email = ContactMailer.send_contact_us_email(user, message)

      expect(email.to.first).to eq(ENV['CTRL_ADMIN_EMAIL'])
      expect(email.subject).to eq("New CTRL contact form submission - from #{user.first_name} #{user.family_name}")
      expect(email.from.first).to eq('ctrl@australiangenomics.org.au')
    end

    it 'it should send copy of message to user' do
      email = ContactMailer.send_contact_us_email(user, message, false)

      expect(email.to.first).to eq(user.email)
      expect(email.subject).to eq('A copy of your message submitted to CTRL Administration Team')
      expect(email.from.first).to eq('ctrl@australiangenomics.org.au')
    end
  end
end
