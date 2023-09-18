ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation

  actions :all, except: [:new]

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
    column('record_id', humanize_name: false, &:id)

    ConsentQuestion.all.each do |consent_question|
      consent_question_id = consent_question.id
      redcap_field = consent_question.redcap_field

      next if redcap_field.blank?

      column(redcap_field, humanize_name: false) do |user|
        question_answer = QuestionAnswer.find_by(
          user_id: user.id,
          consent_question_id: consent_question_id
        )
        if question_answer.nil?
          ''
        else
          Redcap.answer_string_to_code(question_answer.answer)
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

  controller do
    def update
      @user = User.find(params[:id])
      @user.assign_attributes(permitted_params[:user])
      @user.skip_validation = true
      if @user.save
        redirect_to admin_user_path(@user), notice: 'User was successfully updated!'
      else
        render :edit
      end
    end
  end
end
