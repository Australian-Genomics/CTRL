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

  csv do
    column :id
    column(:user_id) do |question_answer|
      question_answer.user_id
    end
    column(:participant_id_id) do |question_answer|
      question_answer.user.participant_id
    end
    column(:user_first_name) do |question_answer|
      question_answer.user.first_name
    end
    column(:user_middle_name) do |question_answer|
      question_answer.user.middle_name
    end
    column(:user_family_name) do |question_answer|
      question_answer.user.family_name
    end
    column(:consent_question) do |question_answer|
      question_answer.consent_question.question
    end
    column :answer
    column(:answer_redcap_field) do |question_answer|
      redcap_response = Redcap.question_answer_to_redcap_response(
        record: question_answer
      ) || [{}]

      redcap_response.first.except('record_id').keys.first
    end
    column(:answer_redcap_code) do |question_answer|
      redcap_response = Redcap.question_answer_to_redcap_response(
        record: question_answer
      ) || [{}]

      redcap_response.first.except('record_id').values.first
    end
    column :created_at
    column :updated_at
  end

  filter :answer
  filter :user_id
  filter :consent_question_id
  filter :updated_at
end
