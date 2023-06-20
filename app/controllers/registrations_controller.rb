class RegistrationsController < Devise::RegistrationsController
  include NextOfKinRegistrationValidator

  def initialize
    super
    @next_of_kin_needed_to_register = next_of_kin_needed_to_register?
  end

  def new
    @user = User.new
    render 'new'
  end

  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      study = Study.find_by(name: 'default')
      study_user = StudyUser.new(
        user: resource,
        study: study,
        participant_id: params[:user][:participant_id]
      )
      if study_user.save
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        resource.errors.add(:participant_id, 'Invalid')
        resource.destroy
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end


  protected

  def after_sign_up_path_for(_resource)
    consent_form_path
  end
end
