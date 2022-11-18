class UploadRedcapDetails
  def self.call_api(payload)
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
      if response.parsed_response['count'] != 1
        count = response.parsed_response['count']
        msg = "Expected to modify 1 record, modified #{count}"
        Rails.logger.error(msg)
        Rollbar.error(msg)
        raise StandardError.new msg
      end
    rescue HTTParty::Error, SocketError => e
      msg = "Error connecting to REDCap - #{e.message}"
      Rails.logger.error(msg)
      Rollbar.error(msg)
      raise
    end
  end

  def self.make_redcap_api_payload(data)
    data.nil? ? nil : {
      token: REDCAP_TOKEN,
      content: 'record',
      format: 'json',
      type: 'flat',
      data: data.to_json
    }
  end

  def self.answer_string_to_code(answer_string)
    case answer_string.downcase
    when 'yes' then '1'
    when 'no' then '0'
    else nil
    end
  end

  def self.question_answer_to_redcap_response(question_answer, destroy, *_)
    answer_string = question_answer.answer

    consent_question = question_answer.consent_question

    raw_redcap_code = consent_question
      .question_options
      .where('LOWER(value) = ?', answer_string)
      .first
      &.redcap_code

    raw_redcap_field = consent_question.redcap_field

    question_type = consent_question.question_type

    user_id = question_answer.user_id

    construct_redcap_response(
      raw_redcap_code,
      raw_redcap_field,
      answer_string,
      question_type,
      user_id,
      destroy
    )
  end

  def self.user_to_redcap_response(user, *_)
    user_id = user.id

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
          {'record_id' => user_id} :
          {'record_id' => user_id, 'redcap_event_name' => redcap_event_name}

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
    user_id,
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
        'record_id' => user_id,
        redcap_field => redcap_code,
      }
    ]
  end

  def self.perform(data_getter, record, destroy=false)
    Rails.logger.info "Using #{data_getter} to perform upload job for #{record.pretty_inspect}"
    data = self.send(data_getter, record, destroy)
    if data.nil?
      Rails.logger.info "Payload empty; Not posting for #{record.pretty_inspect}"
      return
    end
    redcap_api_payload = make_redcap_api_payload(data)
    call_api(redcap_api_payload)
  end
end
