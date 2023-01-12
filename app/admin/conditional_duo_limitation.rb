ActiveAdmin.register ConditionalDuoLimitation do
  permit_params :json

  index do
    selectable_column
    id_column
    column :json
    column :consent_questions
    # TODO: Merge json permissions when sending
    actions
  end

  show do |f|
    attributes_table do
      row :json
      row :consent_questions
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs 'Conditional Duo Limitation' do
      f.input :json
    end

    f.actions
  end
end
