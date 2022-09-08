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
  'study_id',
  'term',
  'title',
  'tour_videos',
  'value',

  'small_note',
  'cancel_btn',
  'review_answers_btn',
]

$permitted_record_types = Set[
  'AdminUser',
  'ConsentGroup',
  'ConsentQuestion',
  'ConsentStep',
  'GlossaryEntry',
  'ModalFallback',
  'QuestionOption',
  'StudyCode',
  'SurveyConfig',
  'User',
]

def filter_permitted_keys(record)
  record.attributes.select do |key, value|
    $permitted_fields.member? key and not value.nil?
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
    .map{ |a| a.name }

  association_names.reduce({}) do |accumulator, association_name|
    related_records = record
      .send(association_name)
      .select { |related_record|
        $permitted_record_types.member? related_record.class.to_s }

    related_records_as_yaml = related_records
      .map { |related_record|
        record_to_yaml(related_record) }

    if not related_records.empty?
      record_type = related_records.first.class.to_s
      accumulator[record_type] = related_records_as_yaml
    end
    accumulator
  end
end

def fetch_records_of_type(record_type)
  records = case record_type
    when "AdminUser"       then AdminUser.all
    when "ConsentGroup"    then ConsentGroup.all
    when "ConsentQuestion" then ConsentQuestion.all
    when "ConsentStep"     then ConsentStep.all
    when "GlossaryEntry"   then GlossaryEntry.all
    when "ModalFallback"   then ModalFallback.all
    when "QuestionOption"  then QuestionOption.all
    when "StudyCode"       then StudyCode.all
    when "SurveyConfig"    then SurveyConfig.all
    when "User"            then User.all
    else raise ArgumentError.new("No such record type: #{record_type}")
  end

  filtered_records = records.map do |record|
    record_to_yaml(record)
  end

  { record_type => filtered_records }
end

def fetch_records
  [
    # fetch_records_of_type('StudyCode'),
    # fetch_records_of_type('AdminUser'),
    # fetch_records_of_type('User'),
    fetch_records_of_type('SurveyConfig'),
    fetch_records_of_type('GlossaryEntry'),
    fetch_records_of_type('ConsentStep'),
  ]
end

records_array = fetch_records
path = Rails.root.join('db', 'exported-data.yml')
File.write(path, records_array.to_yaml)
