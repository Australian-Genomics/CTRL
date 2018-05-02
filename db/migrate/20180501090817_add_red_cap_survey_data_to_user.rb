class AddRedCapSurveyDataToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :red_cap_survey_one_link, :string
    add_column :users, :red_cap_survey_one_return_code, :string
    add_column :users, :red_cap_survey_one_status, :integer
    add_column :users, :survey_one_email_sent, :boolean, default: false
    add_column :users, :survey_one_email_reminder_sent, :boolean, default: false

    add_column :users, :red_cap_survey_two_link, :string
    add_column :users, :red_cap_survey_two_return_code, :string
    add_column :users, :red_cap_survey_two_status, :integer
    add_column :users, :survey_two_email_sent, :boolean, default: false
    add_column :users, :survey_two_email_reminder_sent, :boolean, default: false

    add_column :users, :red_cap_date_consent_signed, :date
    add_column :users, :red_cap_date_of_result_disclosure, :date
  end
end
