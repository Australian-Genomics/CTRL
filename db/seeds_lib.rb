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

  # Check if the relation exists before attempting to create a new record
  raise ArgumentError, "No such record type: #{related_record_type}" unless record.class.reflect_on_association(related_record_type.underscore.pluralize.to_sym)

  fields_, related_records_hash_ = fields_and_related_records(related_records_hash)

  # Create the new record
  new_record = record.send(related_record_type.underscore.pluralize).new(fields_)

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

def create_join(record_hash)
  record_hash.map do |record_type, records_hash|
    kwargs = records_hash.map do |k, v|
      if k =~ /^[A-Z]/
        [k.downcase, k.constantize.find_by(**v)]
      else
        [k, v]
      end
    end.to_h

    new_record = record_type.constantize.new(**kwargs)
    new_record.save!
    new_record
  end
end

def create_record_of_type(record_type, record_hash)
  assert_type(record_type, String)
  assert_type(record_hash, Hash)

  fields_hash, related_records_hash = fields_and_related_records(record_hash)

  if record_type == 'join'
    new_records = create_join(record_hash)
  else
    new_record = record_type.constantize.new(fields_hash)
    new_records = [new_record] + create_related_records(
      new_record,
      related_records_hash
    )
    new_record.save!
  end

  new_records
end

def create_records_of_type(record_type, records_array)
  assert_type(record_type, String)
  assert_type(records_array, Array)

  records_array.flat_map do |record_hash|
    create_record_of_type(record_type, record_hash)
  end
end

def destroy_all_joins(records_array)
  assert_type(records_array, Array)
  records_array.each do |record_hash|
    assert_type(record_hash, Hash)
  end

  records_array.each do |record_hash|
    record_hash.each_key do |record_type|
      record_type.constantize.destroy_all
    end
  end
end

def destroy_all_records_of_type(record_type, record_array)
  if record_type == 'join'
    destroy_all_joins(record_array)
  else
    record_type.constantize.destroy_all
  end
end

def replace_records(records_array)
  assert_type(records_array, Array)
  records_array.each do |record_hash|
    assert_type(record_hash, Hash)
    record_hash.flat_map do |record_type, record_array|
      destroy_all_records_of_type(record_type, record_array)
    end
  end

  records_array.flat_map do |record_hash|
    record_hash.flat_map do |record_type, records_array_|
      create_records_of_type(record_type, records_array_)
    end
  end
end
