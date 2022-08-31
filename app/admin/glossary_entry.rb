ActiveAdmin.register GlossaryEntry do
  permit_params :term, :definition

  index do
    selectable_column
    id_column
    column :term
    column :definition
    actions
  end

  filter :term
  filter :updated_at
end
