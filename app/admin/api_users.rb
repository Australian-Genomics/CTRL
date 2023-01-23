ActiveAdmin.register ApiUser do
  permit_params :name

  index do
    selectable_column
    id_column
    column :name
    column :created_at
    actions
  end

  show do |f|
    attributes_table do
      row :name
      row :created_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end

  controller do
    def create
      name = params[:api_user][:name]

      token = SecureRandom.hex(40)
      token_digest = Digest::SHA256.hexdigest(token)

      api_user = ApiUser.create(name: name, token_digest: token_digest)

      notice = (
        "This is your new API token, which will only be shown once: #{token}")

      if api_user.invalid?
        redirect_to new_admin_api_user_path, flash: {error: api_user.errors.full_messages.first}
      else
        redirect_to admin_api_users_path, notice: notice
      end
    end
  end
end
