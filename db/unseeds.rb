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
  'ParticipantIdFormat',
  'SurveyConfig',
  'User',
  'UserColumnToRedcapFieldMapping',
]

def filter_permitted_keys(record)
  record.attributes.select do |key, value|
    $permitted_fields.member?(key) && (!value.nil?)
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
                      .map { |a| a.name }

  association_names.each_with_object({}) do |association_name, accumulator|
    related_records = record
                      .send(association_name)
                      .select do |related_record|
        $permitted_record_types.member? related_record.class.to_s end
                      .sort_by do |related_record|
        related_record.respond_to?(:created_at) ?
        related_record.created_at :
        related_record.id end

    related_records_as_yaml = related_records
                              .map do |related_record|
        record_to_yaml(related_record) end

    unless related_records.empty?
      record_type = related_records.first.class.to_s
      accumulator[record_type] = related_records_as_yaml
    end

  end
end

def fetch_records_of_type(record_type)
  records = case record_type
            when 'AdminUser'                      then AdminUser.all
            when 'ConsentGroup'                   then ConsentGroup.all
            when 'ConsentQuestion'                then ConsentQuestion.all
            when 'ConsentStep'                    then ConsentStep.all
            when 'GlossaryEntry'                  then GlossaryEntry.all
            when 'ModalFallback'                  then ModalFallback.all
            when 'QuestionOption'                 then QuestionOption.all
            when 'ParticipantIdFormat'            then ParticipantIdFormat.all
            when 'SurveyConfig'                   then SurveyConfig.all
            when 'User'                           then User.all
            when 'UserColumnToRedcapFieldMapping' then UserColumnToRedcapFieldMapping.all
            when 'ConditionalDuoLimitation'       then ConditionalDuoLimitation.all
    else raise ArgumentError, "No such record type: #{record_type}"
  end

  filtered_records = records.map do |record|
    record_to_yaml(record)
  end

  { record_type => filtered_records }
end

def fetch_records
  [
    fetch_records_of_type('ParticipantIdFormat'),
    fetch_records_of_type('UserColumnToRedcapFieldMapping'),
    fetch_records_of_type('SurveyConfig'),
    fetch_records_of_type('GlossaryEntry'),
    fetch_records_of_type('ConsentStep')
  ]
end
