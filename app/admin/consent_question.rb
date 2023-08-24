ActiveAdmin.register ConsentQuestion do
  permit_params :question,
                :description,
                :redcap_field,
                :is_published,
                :answer_choices_position,
                :image,
                :remove_image

  index do
    selectable_column
    id_column
    column :question
    column :description
    column :is_published
    column :conditional_duo_limitations
    column :image do |consent_question|
      if consent_question.image.attached?
        image_tag url_for(consent_question.image), class: 'question-image'
      end
    end
    column :updated_at
    toggle_bool_column 'Publish Status', :is_published, success_message: 'Publish Status Updated Successfully!'
    actions
  end
  index do
    tag_column :is_published, interactive: true
  end

  show do |_f|
    attributes_table do
      row :order
      row :consent_group
      row :question
      row :description
      row :redcap_field
      row :default_answer
      row :question_type
      row :answer_choices_position
      row :conditional_duo_limitations
      row :image do |consent_question|
        if consent_question.image.attached?
          image_tag url_for(consent_question.image), class: 'question-image'
        end
      end
      row :created_at
      row :updated_at
      row :is_published
    end
  end

  form do |f|
    f.inputs do
      f.input :order
      f.input :question
      f.input :description
      f.input :redcap_field
      f.input :default_answer
      f.input :question_type
      f.input :answer_choices_position
      f.input :redcap_event_name
      f.input :image,
              as: :file,
              hint: (
                f.object.image.attached? ?
                f.object.image.filename.to_s :
                content_tag(:span, "No image uploaded yet"))
      if f.object.image.attached?
        f.input :remove_image, as: :boolean, label: "Remove image"
      end
    end

    f.actions
  end

  controller do
    def update
      if params[:consent_question][:remove_image] == '1'
        resource.image.purge
      end

      # Remove the remove_image attribute so it doesn't interfere with regular update logic
      params[:consent_question].delete(:remove_image)

      super
    end
  end

  filter :question
  filter :description
  filter :updated_at
end
