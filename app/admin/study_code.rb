ActiveAdmin.register StudyCode do
  permit_params :title

  RESTRICTED_ACTIONS = ["new"]

  controller do
    def action_methods
      if StudyCode.count < 1
        super
      else
        super - RESTRICTED_ACTIONS
      end
    end
  end

  index do
    selectable_column
    id_column
    column :title
    column :created_at
    actions
  end

  filter :title

  form do |f|
    f.inputs do
      f.input :title, hint: hint(f.object.title)
    end
    f.actions
  end
end
