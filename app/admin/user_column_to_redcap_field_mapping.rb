ActiveAdmin.register UserColumnToRedcapFieldMapping do
  permit_params :user_column, :redcap_field, :redcap_event_name

  config.sort_order = 'user_column_asc'

  index do
    selectable_column
    id_column
    column('User Column') do |user_column_to_redcap_field_mapping|
      user_column_to_redcap_field_mapping.user_column.humanize.upcase
    end
    column :redcap_field
    column :redcap_event_name
    actions
  end

  show do
    attributes_table do
      row('User Column') do |user_column_to_redcap_field_mapping|
        user_column_to_redcap_field_mapping.user_column.humanize.upcase
      end
      row :redcap_field
      row :redcap_event_name
    end
  end

  form do |f|
    f.inputs do
      f.input :user_column, :as => :select, :collection => (User.column_names.map do |column_name|
          [column_name.humanize.upcase, column_name]
        end)
      f.input :redcap_field
      f.input :redcap_event_name
    end
    f.actions
  end
end
