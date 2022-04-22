ActiveAdmin.register ConsentQuestion do
  permit_params :question, :description, :redcap_field, :is_published

  index do
    selectable_column
    id_column
    column :question
    column :description
    column :is_published
    column :updated_at
    toggle_bool_column "Publish Status", :is_published, success_message: 'Publish Status Updated Successfully!'
    actions
  end
  index do
    tag_column :is_published, interactive: true
  end



  filter :question
  filter :description
  filter :updated_at
end
