ActiveAdmin.register ConsentQuestion do
  permit_params :question, :description, :redcap_field, :is_published, :answer_choices_position

  index do
    selectable_column
    id_column
    column :question
    column :description
    column :is_published
    column :conditional_duo_limitations
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
      row :created_at
      row :updated_at
      row :is_published
    end
  end

  filter :question
  filter :description
  filter :updated_at
end
