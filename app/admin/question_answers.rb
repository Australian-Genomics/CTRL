ActiveAdmin.register QuestionAnswer do
  permit_params :answer

  index do
    selectable_column

    column :consent_question_id do |question_answer|
      link_to question_answer.consent_question_id, admin_consent_question_path(question_answer.consent_question)
    end

    column :answer

    column :user_id do |question_answer|
      link_to question_answer.user_id, admin_user_path(question_answer.user)
    end

    column :user_email do |question_answer|
      question_answer.user.email
    end

    column :updated_at

    actions
  end

  filter :answer
  filter :user_id
  filter :consent_question_id
  filter :updated_at
end
