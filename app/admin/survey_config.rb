require 'base64'

ActiveAdmin.register SurveyConfig do
  permit_params :value
  actions :index, :show, :new, :create, :update, :edit

  index do
    selectable_column
    id_column
    column :name
    column :value
    actions
  end

  filter :name
  filter :value

  form do |f|
    f.inputs do
      f.input :name, input_html: { disabled: true }
      if f.object.is_file
        f.input :value, as: :file, hint: f.object.hint
      else
        f.input :value, hint: f.object.hint
      end
    end
    f.actions
  end

  controller do
    def update
      attrs = permitted_params[:survey_config]
      value = attrs ? attrs[:value] : ''

      sc = SurveyConfig.find_by(id: params[:id])
      sc.value = if value.instance_of?(ActionDispatch::Http::UploadedFile)
                   Base64.strict_encode64(value.read)
                 else
                   value
                 end

      if sc.save
        redirect_to admin_survey_config_path(sc), notice: 'Survey config was successfully updated.'
      else
        render :edit
      end
    end
  end
end
