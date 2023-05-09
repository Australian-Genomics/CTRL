def assert_type(object, expected_type)
  raise ArgumentError, "Expected #{expected_type}, got #{object}" if object.class != expected_type
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
    related_records_hash
  )
  new_record = case related_record_type
               when 'AdminUser'                      then record.admin_users.new(fields_)
               when 'ConsentGroup'                   then record.consent_groups.new(fields_)
               when 'ConsentQuestion'                then record.consent_questions.new(fields_)
               when 'ConsentStep'                    then record.consent_steps.new(fields_)
               when 'GlossaryEntry'                  then record.glossary_entries.new(fields_)
               when 'ModalFallback'                  then record.modal_fallbacks.new(fields_)
               when 'QuestionOption'                 then record.question_options.new(fields_)
               when 'ParticipantIdFormat'            then record.participant_id_formats.new(fields_)
               when 'SurveyConfig'                   then record.survey_configs.new(fields_)
               when 'User'                           then record.users.new(fields_)
               when 'UserColumnToRedcapFieldMapping' then record.user_column_to_redcap_field_mapping.new(fields_)
               when 'ConditionalDuoLimitation'       then record.conditional_duo_limitations.new(fields_)
               else raise ArgumentError, "No such record type: #{record_type}"
  end

  new_records = [new_record] + create_related_records(new_record, related_records_hash_)
  new_record.save!
  new_records
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
               when 'AdminUser'                      then AdminUser.new(fields_hash)
               when 'ConsentGroup'                   then ConsentGroup.new(fields_hash)
               when 'ConsentQuestion'                then ConsentQuestion.new(fields_hash)
               when 'ConsentStep'                    then ConsentStep.new(fields_hash)
               when 'GlossaryEntry'                  then GlossaryEntry.new(fields_hash)
               when 'ModalFallback'                  then ModalFallback.new(fields_hash)
               when 'QuestionOption'                 then QuestionOption.new(fields_hash)
               when 'ParticipantIdFormat'            then ParticipantIdFormat.new(fields_hash)
               when 'SurveyConfig'                   then SurveyConfig.new(fields_hash)
               when 'User'                           then User.new(fields_hash)
               when 'UserColumnToRedcapFieldMapping' then UserColumnToRedcapFieldMapping.new(fields_hash)
               when 'ConditionalDuoLimitation'       then ConditionalDuoLimitation.new(fields_hash)
               else raise ArgumentError, "No such record type: #{record_type}"
  end

  new_records = [new_record] + create_related_records(new_record, related_records_hash)
  new_record.save!
  new_records
end

def create_records_of_type(record_type, records_array)
  assert_type(record_type, String)
  assert_type(records_array, Array)

  records_array.flat_map do |record_hash|
    create_record_of_type(record_type, record_hash)
  end
end

def destroy_all_records_of_type(record_type)
  case record_type
  when 'AdminUser'                      then AdminUser.destroy_all
  when 'ConsentGroup'                   then ConsentGroup.destroy_all
  when 'ConsentQuestion'                then ConsentQuestion.destroy_all
  when 'ConsentStep'                    then ConsentStep.destroy_all
  when 'GlossaryEntry'                  then GlossaryEntry.destroy_all
  when 'ModalFallback'                  then ModalFallback.destroy_all
  when 'QuestionOption'                 then QuestionOption.destroy_all
  when 'ParticipantIdFormat'            then ParticipantIdFormat.destroy_all
  when 'SurveyConfig'                   then SurveyConfig.destroy_all
  when 'User'                           then User.destroy_all
  when 'UserColumnToRedcapFieldMapping' then UserColumnToRedcapFieldMapping.destroy_all
  when 'ConditionalDuoLimitation'       then ConditionalDuoLimitation.destroy_all
  else raise ArgumentError, "No such record type: #{record_type}"
  end
end

def replace_records(records_array)
  assert_type(records_array, Array)
  records_array.each do |record_hash|
    assert_type(record_hash, Hash)
  end

  records_array.each do |record_hash|
    record_hash.each do |record_type, _|
      destroy_all_records_of_type(record_type)
    end
  end

  records_array.flat_map do |record_hash|
    record_hash.flat_map do |record_type, records_array_|
      create_records_of_type(record_type, records_array_)
    end
  end
end
