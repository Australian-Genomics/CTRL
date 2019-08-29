class UserMailer < ApplicationMailer
  def send_first_survey_email(user)
    @user = user
    @genetic_counsellor = @user.genetic_counsellor
    attach_image 'logo@2x.png'
    attach_image 'Rectangle.png'
    attach_image 'Group.png'

    sender = 'ctrl@australiangenomics.org.au'
    user.update_attribute(:survey_one_email_sent, true)

    mail(to: "#{user.first_name} #{user.family_name} <#{user.email}>", subject: 'Australian Genomics Rare Disease Patient Survey – PART 1', sender: sender, from: sender)
  end

  def attach_image(image_name)
    attachments.inline[image_name] = File.read(File.join(Rails.root, 'app', 'assets', 'images', image_name))
  end

  def send_daily_consent_email_to_matilda
    excel_file = ReportManager.daily_consent_changes_excel_file

    date_time_now_in_zone = Timezone['Australia/Melbourne'].time_with_offset(Time.now)
    @today_date = date_time_now_in_zone.try(:strftime, '%d_%m_%Y')
    filename = "AGHA_Participant_Consent_Preference_Changes_#{@today_date}.xlsx"

    attachments[filename] = { mime_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', content: excel_file.read }

    sender = 'ctrl@australiangenomics.org.au'
    to_email = ENV['DAILY_CHANGES_EMAIL'] || 'aghatesting@gmail.com'
    mail(to: "AGHA CTRL <#{to_email}>", subject: "AGHA Participant Consent Preference Changes for #{@today_date.tr('_', '/')}", sender: sender, from: sender)
  end
end
