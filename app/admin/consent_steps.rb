ActiveAdmin.register ConsentStep do
  permit_params :order, :title, :description, :popover,
  consent_groups_attributes: [
    :id,
    :_destroy,
    :header,
    :order,
    consent_questions_attributes: [
      :id,
      :_destroy,
      :order,
      :question,
      :description,
      :question_type,
      :default_answer,
      :answer_choices_position,
      :redcap_field,
      question_options_attributes: [
        :id,
        :_destroy,
        :value
      ]
    ]
  ],
  modal_fallbacks_attributes: [
    :id,
    :_destroy,
    :description,
    :small_note,
    :review_answers_btn,
    :cancel_btn
  ]

  index do
    selectable_column
    id_column
    column :order
    column :title
    column :description
    column :popover
    column :created_at
    actions
  end

  filter :order
  filter :title
  filter :description
  filter :popover
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs 'Consent Step' do
      f.input :order
      f.input :title
      f.input :description
      f.input :popover
    end

    f.inputs 'Consent Group' do
      f.has_many :consent_groups,
                 new_record: 'Add Group',
                 remove_record: 'Remove Group',
                 sortable: :order,
                 sortable_start: 1,
                allow_destroy: true do |b|
        b.input :header
        b.input :order

        b.has_many :consent_questions,
                 new_record: 'Add Question',
                 remove_record: 'Remove Question',
                 sortable: :order,
                 sortable_start: 1,
                 allow_destroy: true do |c|

          c.input :order
          c.input :question
          c.input :description
          c.input :question_type, as: :select, collection: ConsentQuestion::QUESTION_TYPES
          c.input :default_answer
          c.input :answer_choices_position, as: :select, collection: ConsentQuestion::POSITIONS
          c.input :redcap_field

          c.has_many :question_options,
            new_record: 'Add Multiple Choice Option',
            remove_record: 'Remove Option',
            allow_destroy: true do |d|

            d.input :value
          end
        end
      end
    end

    f.inputs 'Modal Fallback' do
      f.has_many :modal_fallbacks,
                 new_record: 'Add Modal Fallback',
                 remove_record: 'Remove Modal Fallback',
                 allow_destroy: true do |b|

        b.input :description
        b.input :small_note
        b.input :review_answers_btn
        b.input :cancel_btn
      end
    end

    f.actions
  end
end
