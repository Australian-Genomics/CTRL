ActiveAdmin.register Study do
  permit_params :name, :participant_id_format

  index do
    selectable_column
    id_column
    column :name
    column :participant_id_format
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :participant_id_format, hint: hint(f.object.participant_id_format)
    end
    f.actions
  end
end
