ActiveAdmin.register ConsentStep do
  permit_params :order, :title, :description, :popover, :tour_videos,
                consent_groups_attributes: [
                  :id,
                  :_destroy,
                  :header,
                  :order,
                  { consent_questions_attributes: [
                    :id,
                    :_destroy,
                    :order,
                    :question,
                    :description,
                    :question_type,
                    :default_answer,
                    :answer_choices_position,
                    :redcap_field,
                    :redcap_event_name,
                    { question_options_attributes: %i[
                      id
                      _destroy
                      value
                      redcap_code
                      color
                    ] }
                  ] }
                ],
                modal_fallbacks_attributes: %i[
                  id
                  _destroy
                  description
                  small_note
                  review_answers_btn
                  cancel_btn
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

  after_update do |cs|
    unless cs.valid?
      cs.errors.full_messages.each do |error|
        flash[:error] = error
      end
    end
  end

  form do |f|
    f.inputs 'Consent Step' do
      f.input :order
      f.input :title
      f.input :description
      f.input :popover
      f.input :tour_videos, label: 'Tour Videos (Separated by Comma(,)'
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
          c.input :redcap_event_name

          c.has_many :question_options,
                     new_record: 'Add Multiple Choice Option',
                     remove_record: 'Remove Option',
                     allow_destroy: true do |d|
            d.input :value
            d.input :redcap_code
            d.input :color, as: :color_picker, palette: [
              '#000000',
              '#333333',
              '#663300',
              '#CC0000',
              '#CC3300',
              '#FFCC00',
              '#009900',
              '#006666',
              '#0066FF',
              '#0000CC',
              '#663399',
              '#CC0099',
              '#FF9999',
              '#FF9966',
              '#FFFF99',
              '#99FF99',
              '#66FFCC',
              '#99FFFF',
              '#66CCFF',
              '#9999FF',
              '#FF99FF',
              '#FFCCCC',
              '#FFCC99',
              '#f77088'
            ]
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
