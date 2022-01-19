ActiveAdmin.register ConsentQuestion do
  permit_params :question, :description, :redcap_field

  index do
    selectable_column
    id_column
    column :question
    column :description
    column :updated_at

    actions
  end

  filter :question
  filter :description
  filter :updated_at
end
