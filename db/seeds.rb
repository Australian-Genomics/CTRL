def assert_type(object, expected_type)
  if object.class != expected_type
    raise ArgumentError.new("Expected #{expected_type}, got #{object}")
  end
end

def string_specifies_record_type?(string)
  string.match?(/\A[A-Z]/)
end

def fields_and_related_records(record_hash)
  assert_type(record_hash, Hash)

  [
    record_hash.reject { |key| string_specifies_record_type?(key) },
    record_hash.select { |key| string_specifies_record_type?(key) }
  ]
end

def create_related_record_of_type(
  record,
  related_record_type,
  related_records_hash
)
  assert_type(related_record_type, String)
  assert_type(related_records_hash, Hash)

  fields_, related_records_hash_ = fields_and_related_records(
    related_records_hash)
  new_record = case related_record_type
    when "AdminUser"       then record.admin_users.create!(fields_)
    when "ConsentGroup"    then record.consent_groups.create!(fields_)
    when "ConsentQuestion" then record.consent_questions.create!(fields_)
    when "ConsentStep"     then record.consent_steps.create!(fields_)
    when "GlossaryEntry"   then record.glossary_entries.create!(fields_)
    when "ModalFallback"   then record.modal_fallbacks.create!(fields_)
    when "QuestionOption"  then record.question_options.create!(fields_)
    when "StudyCode"       then record.study_codes.create!(fields_)
    when "SurveyConfig"    then record.survey_configs.create!(fields_)
    when "User"            then record.users.create!(fields_)
    else raise ArgumentError.new("No such record type: #{record_type}")
  end

  [new_record] + create_related_records(new_record, related_records_hash_)
end

def create_related_records_of_type(
  record, related_record_type, related_records_array
)
  assert_type(related_record_type, String)
  assert_type(related_records_array, Array)

  related_records_array.flat_map do |related_record_hash|
    create_related_record_of_type(
      record,
      related_record_type,
      related_record_hash
    )
  end
end

def create_related_records(record, related_records_hash)
  assert_type(related_records_hash, Hash)

  related_records_hash.flat_map do |related_record_type, related_records_array|
    create_related_records_of_type(
      record,
      related_record_type,
      related_records_array
    )
  end
end

def create_record_of_type(record_type, record_hash)
  assert_type(record_type, String)
  assert_type(record_hash, Hash)

  fields_hash, related_records_hash = fields_and_related_records(record_hash)
  new_record = case record_type
    when "AdminUser"       then AdminUser.create!(fields_hash)
    when "ConsentGroup"    then ConsentGroup.create!(fields_hash)
    when "ConsentQuestion" then ConsentQuestion.create!(fields_hash)
    when "ConsentStep"     then ConsentStep.create!(fields_hash)
    when "GlossaryEntry"   then GlossaryEntry.create!(fields_hash)
    when "ModalFallback"   then ModalFallback.create!(fields_hash)
    when "QuestionOption"  then QuestionOption.create!(fields_hash)
    when "StudyCode"       then StudyCode.create!(fields_hash)
    when "SurveyConfig"    then SurveyConfig.create!(fields_hash)
    when "User"            then User.create!(fields_hash)
    else raise ArgumentError.new("No such record type: #{record_type}")
  end

  [new_record] + create_related_records(new_record, related_records_hash)
end

def create_records_of_type(record_type, records_array)
  assert_type(record_type, String)
  assert_type(records_array, Array)

  records_array.flat_map do |record_hash|
    create_record_of_type(record_type, record_hash)
  end
end

def create_records(records_array)
  assert_type(records_array, Array)

  records_array.flat_map do |record_hash|
    assert_type(record_hash, Hash)

    record_hash.flat_map do |record_type, records_array_|
      create_records_of_type(record_type, records_array_)
    end
  end
end

path = Rails.root.join('db', 'data.yml')
records_array = YAML::load_file(path)
records = create_records(records_array)

puts "
=============================
RECORDS CREATED SUCCESSFULLY:
============================="
records.each do |record|
  puts
  pp record
end
