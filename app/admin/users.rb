ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  csv do
    column('record_id', humanize_name: false) do |user|
      user.id
    end

    ConsentQuestion.all.each do |consent_question|
      consent_question_id = consent_question.id
      redcap_field = consent_question.redcap_field

      if redcap_field.blank?
        next
      end

      column(redcap_field, humanize_name: false) do |user|
        question_answer = QuestionAnswer.find_by(
          user_id: user.id,
          consent_question_id: consent_question_id,
        )
        if question_answer.nil?
          ''
        else
          UploadRedcapDetails.answer_string_to_code(question_answer.answer)
        end
      end
    end
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
