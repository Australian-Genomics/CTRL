require 'ostruct'

class Redcap
  def self.filter_repeat_instruments(redcap_details)
    if redcap_details.nil?
      nil
    else
      redcap_details.select do |record|
        record["redcap_repeat_instrument"].blank?
      end
    end
  end

  def self.call_api(payload, expected_count: nil, **_)
    unless REDCAP_CONNECTION_ENABLED
      Rails.logger.info("Connection disabled; not posting payload: #{payload}")
      return
    end

    begin
      response = HTTParty.post(REDCAP_API_URL, body: payload)

      Rails.logger.info("Posted payload: #{payload}")

      unless response.success?
        msg = "Unsuccessful response from REDCap: #{response}"
        Rails.logger.error(msg)
        Rollbar.error(msg)
        raise StandardError, msg
      end

      parsed_response = response.parsed_response

      if !expected_count.nil? && parsed_response['count'] != expected_count
        count = parsed_response['count']
        msg = "Expected to modify #{expected_count} record, modified #{count}"
        Rails.logger.error(msg)
        Rollbar.error(msg)
        raise StandardError, msg
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
    if data.nil?
      nil
    else
      {
        token: REDCAP_TOKEN,
        content: 'record',
        format: 'json',
        type: 'flat',
        data: data.to_json
      }
    end
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
    if data.nil?
      nil
    else
      {
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
      }.merge(data.event_name.nil? ? {} : { 'events[0]': data.event_name })
    end
  end

  def self.answer_string_to_code(answer_string)
    case answer_string.downcase
    when 'yes' then '1'
    when 'no' then '0'
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

    raw_redcap_event_name = consent_question.redcap_event_name

    question_type = consent_question.question_type

    participant_id = question_answer.user.participant_id

    construct_redcap_response(
      raw_redcap_code,
      raw_redcap_field,
      raw_redcap_event_name,
      answer_string,
      question_type,
      participant_id,
      destroy
    )
  end

  def self.user_to_export_redcap_response(record: nil, **_)
    redcap_event_name = UserColumnToRedcapFieldMapping.find_by(
      user_column: 'email'
    )&.redcap_event_name

    OpenStruct.new(
      record_id: record.participant_id,
      event_name: redcap_event_name.blank? ? nil : redcap_event_name
    )
  end

  def self.user_to_import_redcap_response(record: nil, **_)
    user = record

    return nil if UserColumnToRedcapFieldMapping.count.zero?

    participant_id = user.participant_id

    UserColumnToRedcapFieldMapping.all.map do |user_column_to_redcap_field_mapping|
      user_column = user_column_to_redcap_field_mapping.user_column
      redcap_field = user_column_to_redcap_field_mapping.redcap_field
      redcap_event_name = user_column_to_redcap_field_mapping.redcap_event_name

      is_dropdown = User.defined_enums.key?(user_column)

      user_column_value =
        if is_dropdown
          user.read_attribute_before_type_cast(user_column)
        else
          user.send(user_column)
        end

      response_base =
        if redcap_event_name.blank?
          { 'record_id' => participant_id }
        else
          { 'record_id' => participant_id, 'redcap_event_name' => redcap_event_name }
        end

      if user_column_value.nil?
        nil
      elsif is_dropdown
        # Rails stores menu entries in the database as zero-indexed integers.
        # REDCap stores menu entries as one-indexed integers. We must
        # increment Rails' integer to get one which REDCap understands.
        response_base.merge(redcap_field => user_column_value + 1)
      elsif user_column_value == true
        response_base.merge(redcap_field => '1')
      elsif user_column_value == false
        response_base.merge(redcap_field => '0')
      else
        response_base.merge(redcap_field => user_column_value)
      end
    end.compact
  end

  def self.construct_redcap_response( # rubocop:disable Metrics/ParameterLists
    raw_redcap_code,
    raw_redcap_field,
    raw_redcap_event_name,
    answer_string,
    question_type,
    participant_id,
    destroy
  )
    return if raw_redcap_field.blank?

    coded_answer_or_raw_redcap_code =
      if raw_redcap_code.nil?
        answer_string_to_code(answer_string)
      else
        raw_redcap_code
      end

    if question_type == 'multiple checkboxes'
      redcap_field = "#{raw_redcap_field}___#{coded_answer_or_raw_redcap_code}"
      redcap_code = destroy ? '0' : '1'
    else
      redcap_field = raw_redcap_field
      redcap_code = coded_answer_or_raw_redcap_code
    end

    [
      {
        'record_id' => participant_id,
        redcap_field => redcap_code
      }.merge(
        if raw_redcap_event_name.blank?
          {}
        else
          { 'redcap_event_name' => raw_redcap_event_name }
        end
      )
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

    data = send(data_fetcher, record: record, **kwargs)
    if data.nil?
      Rails.logger.info "Payload empty; Not posting for #{record.pretty_inspect}"
      return
    end

    redcap_api_payload = send(payload_maker, data)

    call_api(redcap_api_payload, **kwargs)
  end
end
