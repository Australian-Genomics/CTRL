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
    params = sign_up_params
    study_name = params['study_name']
    params.delete('study_name')

    study = Study.find_by(name: study_name)

    build_resource(params)
    resource.save
    yield resource if block_given?
    if study.nil?
      resource.errors.add(:study_name, 'Invalid')
      clean_up resource
    elsif resource.persisted?
      study_user = StudyUser.new(
        user: resource,
        study: study,
        participant_id: params['participant_id']
      )

      if study_user.save
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          user_session['study_name'] = study_name
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        resource.errors.add(:participant_id, 'Invalid')
        clean_up resource
      end
    else
      clean_up resource
    end
  end

  protected

  def clean_up(resource)
    resource.destroy
    clean_up_passwords resource
    set_minimum_password_length
    respond_with resource
  end

  def after_sign_up_path_for(_resource)
    consent_form_path
  end
end
