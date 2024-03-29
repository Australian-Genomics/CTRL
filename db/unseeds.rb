# frozen_string_literal: true

# rubocop:disable Style/GlobalVars

$permitted_fields = Set[
  'answer_choices_position',
  'default_answer',
  'definition',
  'description',
  'dob',
  'email',
  'family_name',
  'first_name',
  'header',
  'hint',
  'is_file',
  'name',
  'order',
  'password',
  'password_confirmation',
  'popover',
  'question',
  'question_type',
  'participant_id',
  'participant_id_format',
  'term',
  'title',
  'tour_videos',
  'value',
  'small_note',
  'cancel_btn',
  'review_answers_btn',
  'user_column',
  'redcap_field',
  'redcap_event_name',
  'json',
]

$permitted_record_types = Set[
  'AdminUser',
  'ConditionalDuoLimitation',
  'ConsentGroup',
  'ConsentQuestion',
  'ConsentStep',
  'GlossaryEntry',
  'ModalFallback',
  'QuestionOption',
  'Study',
  'SurveyConfig',
  'User',
  'UserColumnToRedcapFieldMapping',
]

def filter_permitted_keys(record)
  record.attributes.select do |key, value|
    $permitted_fields.member?(key) && !value.nil?
  end
end

def record_to_yaml(record)
  {}
    .merge(filter_permitted_keys(record))
    .merge(fetch_related_records(record))
end

def fetch_related_records(record)
  association_names = record
                      .class
                      .reflect_on_all_associations(:has_many)
                      .map(&:name)
                      .filter { |n| !%i[studies users study_users].include?(n) }

  association_names.each_with_object({}) do |association_name, accumulator|
    unsorted_related_records =
      record
      .send(association_name)
      .select do |related_record|
        $permitted_record_types.member? related_record.class.to_s
      end

    related_records =
      unsorted_related_records
      .sort_by do |related_record|
        if related_record.respond_to?(:created_at)
          related_record.created_at
        else
          related_record.id
        end
      end

    related_records_as_yaml =
      related_records.map do |related_record|
        record_to_yaml(related_record)
      end

    unless related_records.empty?
      record_type = related_records.first.class.to_s
      accumulator[record_type] = related_records_as_yaml
    end
  end
end

def fetch_records_of_type(record_type)
  records = record_type.constantize.all

  filtered_records = records.map do |record|
    record_to_yaml(record)
  end

  { record_type => filtered_records }
end

def fetch_records
  [
    fetch_records_of_type('UserColumnToRedcapFieldMapping'),
    fetch_records_of_type('SurveyConfig'),
    fetch_records_of_type('Study'),
    fetch_records_of_type('ConditionalDuoLimitation'),
    {
      'join' => [
        'StudyUser' => StudyUser.all.map do |study_user|
          {
            'User' => { 'email' => study_user.user.email },
            'Study' => { 'name' => study_user.study.name },
            'participant_id' => study_user.participant_id
          }
        end
      ]
    }
  ]
end

# rubocop:enable Style/GlobalVars
