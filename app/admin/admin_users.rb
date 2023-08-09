ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, :otp_required_for_login

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
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

  action_item :edit_two_factor, only: :show do
    link_to(
      'Set-up 2FA',
      edit_two_factor_admin_admin_user_path(admin_user)
    )
  end

  member_action :edit_two_factor, method: :get do
    @admin_user = AdminUser.find(params[:id])
    respond_to do |f|
      f.html do
        render template: 'admin/admin_user/edit_two_factor'
      end
    end
  end

  member_action :update_two_factor, method: :patch do
    admin_user = AdminUser.find(params[:id])
    admin_user.update!(permitted_params[:admin_user])
    admin_user.reload # TODO: necessary?
    if admin_user.otp_required_for_login && !admin_user.otp_secret.present?
      admin_user.otp_secret = AdminUser.generate_otp_secret
      admin_user.save!
    end
    @admin_user = admin_user.reload # TODO: necessary?
    flash[:notice] = 'Successfully updated!'
    render template: 'admin/admin_user/edit_two_factor'
  rescue StandardError => e
    flash[:error] = e
    redirect_to edit_two_factor_admin_admin_user_path(params[:id])
  end
end
