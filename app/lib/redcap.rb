require 'ostruct'

class Redcap
  def self.call_api(payload, expected_count: nil, **_)
    if !REDCAP_CONNECTION_ENABLED
      Rails.logger.info("Connection disabled; not posting payload: #{payload}")
      return
    end

    begin
      response = HTTParty.post(REDCAP_API_URL, body: payload)

      Rails.logger.info("Posted payload: #{payload}")

      if !response.success?
        msg = "Unsuccessful response from REDCap: #{response}"
        Rails.logger.error(msg)
        Rollbar.error(msg)
        raise StandardError.new msg
      end

      parsed_response = response.parsed_response

      if !expected_count.nil? && parsed_response['count'] != expected_count
        count = parsed_response['count']
        msg = "Expected to modify #{expected_count} record, modified #{count}"
        Rails.logger.error(msg)
        Rollbar.error(msg)
        raise StandardError.new msg
      end

      parsed_response
    rescue HTTParty::Error, SocketError => e
      msg = "Error connecting to REDCap - #{e.message}"
      Rails.logger.error(msg)
      Rollbar.error(msg)
      raise
    end
  end

  # Constructs a REDCap API payload which imports +data+. Example data:
  #
  # [
  #   {
  #     'record_id' => '42',
  #     'my_redcap_field' => 'new REDCap field value'
  #   }
  # ]
  #
  def self.get_import_payload(data)
    data.nil? ? nil : {
      token: REDCAP_TOKEN,
      content: 'record',
      format: 'json',
      type: 'flat',
      data: data.to_json
    }
  end

  # Constructs a REDCap API payload which exports all records having the given
  # +record_id+. There will be between one and zero such records.
  #
  # Example HTTP response: [
  #   {
  #     'my_field_name': 'field value from REDCap',
  #     'my_other_field_name': 'other field value from REDCap'
  #   }
  # ]
  #
  def self.get_export_payload(data)
    data.nil? ? nil : {
      token: REDCAP_TOKEN,
      content: 'record',
      action: 'export',
      format: 'json',
      type: 'flat',
      csvDelimiter: '',
      'records[0]': data.record_id,
      rawOrLabel: 'raw',
      rawOrLabelHeaders: 'raw',
      exportCheckboxLabel: 'false',
      exportSurveyFields: 'false',
      exportDataAccessGroups: 'false',
      returnFormat: 'json'
    }.merge(data.event_name.nil? ? {} : {
      'events[0]': data.event_name,
    })
  end

  def self.answer_string_to_code(answer_string)
    case answer_string.downcase
    when 'yes' then '1'
    when 'no' then '0'
    else nil
    end
  end

  def self.identity_data_fetcher(record: nil, **_)
    record
  end

  def self.question_answer_to_redcap_response(record: nil, destroy: false, **_)
    question_answer = record

    answer_string = question_answer.answer

    consent_question = question_answer.consent_question

    raw_redcap_code = consent_question
      .question_options
      .where('LOWER(value) = ?', answer_string)
      .first
      &.redcap_code

    raw_redcap_field = consent_question.redcap_field

    question_type = consent_question.question_type

    study_id = question_answer.user.study_id

    construct_redcap_response(
      raw_redcap_code,
      raw_redcap_field,
      answer_string,
      question_type,
      study_id,
      destroy
    )
  end

  def self.user_to_export_redcap_response(record: nil, **_)
    redcap_event_name = UserColumnToRedcapFieldMapping.find_by(
      user_column: 'email'
    )&.redcap_event_name

    OpenStruct.new({
      :record_id => record.study_id,
      :event_name => redcap_event_name.blank? ? nil : redcap_event_name,
    })
  end

  def self.user_to_import_redcap_response(record: nil, **_)
    user = record

    if UserColumnToRedcapFieldMapping.count == 0
      return nil
    end

    study_id = user.study_id

    UserColumnToRedcapFieldMapping.all.map { |user_column_to_redcap_field_mapping|
      user_column, redcap_field, redcap_event_name = [
        user_column_to_redcap_field_mapping.user_column,
        user_column_to_redcap_field_mapping.redcap_field,
        user_column_to_redcap_field_mapping.redcap_event_name]

      is_dropdown = User.defined_enums.has_key?(user_column)

      user_column_value =
        is_dropdown ?
          user.read_attribute_before_type_cast(user_column) :
          user.send(user_column)

      response_base =
        redcap_event_name.blank? ?
          {'record_id' => study_id} :
          {'record_id' => study_id, 'redcap_event_name' => redcap_event_name}

      if user_column_value.nil?
        {}
      elsif is_dropdown
        # Rails stores menu entries in the database as zero-indexed integers.
        # REDCap stores menu entries as one-indexed integers. We must
        # increment Rails' integer to get one which REDCap understands.
        response_base.merge({redcap_field => user_column_value + 1})
      elsif user_column_value == true
        response_base.merge({redcap_field => '1'})
      elsif user_column_value == false
        response_base.merge({redcap_field => '0'})
      else
        response_base.merge({redcap_field => user_column_value})
      end
    }.select { |response_hash|
      response_hash != {}
    }
  end

  def self.construct_redcap_response(
    raw_redcap_code,
    raw_redcap_field,
    answer_string,
    question_type,
    study_id,
    destroy
  )
    if raw_redcap_field.blank?
      return
    end

    coded_answer_or_raw_redcap_code = raw_redcap_code.nil? ?
      answer_string_to_code(answer_string) :
      raw_redcap_code

    if question_type == "multiple checkboxes"
      redcap_field = "#{raw_redcap_field}___#{coded_answer_or_raw_redcap_code}"
      redcap_code = destroy ? '0' : '1'
    else
      redcap_field = raw_redcap_field
      redcap_code = coded_answer_or_raw_redcap_code
    end

    [
      {
        'record_id' => study_id,
        redcap_field => redcap_code,
      }
    ]
  end

  # +data_fetcher+ queries the database to fetch data required by the REDCap API
  # call. It must be one of the following:
  #   * :question_answer_to_redcap_response
  #   * :user_to_export_redcap_response
  #   * :user_to_import_redcap_response
  #
  # +payload_maker+ takes data from +data_fetcher+ and produces a REDCap API
  # payload. It must be one of the following:
  #   * :get_import_payload
  #   * :get_export_payload
  #
  # Keyword arguments:
  #   * record - The Rails record to call +data_fetcher+ on.
  #   * expected_count - The number of records expected to be modified.
  #   * destroy - A boolean value indicating whether the record should be destroyed in REDCap.
  #
  def self.perform(data_fetcher, payload_maker, record: nil, **kwargs)
    Rails.logger.info "Using #{data_fetcher} to perform job for #{record.pretty_inspect}"

    data = self.send(data_fetcher, record: record, **kwargs)
    if data.nil?
      Rails.logger.info "Payload empty; Not posting for #{record.pretty_inspect}"
      return
    end

    redcap_api_payload = self.send(payload_maker, data)

    call_api(redcap_api_payload, **kwargs)
  end
end
