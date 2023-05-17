ActiveAdmin.register ParticipantIdFormat do
  permit_params :participant_id_format

  RESTRICTED_ACTIONS = ['new'].freeze

  controller do
    def action_methods
      if ParticipantIdFormat.count < 1
        super
      else
        super - RESTRICTED_ACTIONS
      end
    end
  end

  index do
    selectable_column
    id_column
    column :participant_id_format
    column :created_at
    actions
  end

  filter :participant_id_format

  form do |f|
    f.inputs do
      f.input :participant_id_format, hint: hint(f.object.participant_id_format)
    end
    f.actions
  end
end
