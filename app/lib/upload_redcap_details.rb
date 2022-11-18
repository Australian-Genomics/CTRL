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
      data: data
    }
  end

  def self.answer_string_to_code(answer_string)
    case answer_string.downcase
    when 'yes' then '1'
    when 'no' then '0'
    else nil
    end
  end

  def self.question_answer_to_redcap_response(question_answer, destroy)
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

    data = {
      'record_id' => user_id,
      redcap_field => redcap_code,
    }
  end

  def self.perform(question_answer, destroy=false)
    Rails.logger.info "Performing upload job for question=#{question_answer.pretty_inspect}"
    data = question_answer_to_redcap_response(question_answer, destroy)
    if data.nil?
      Rails.logger.info "Payload empty; Not posting for question=#{question_answer.pretty_inspect}"
      return
    end
    redcap_api_payload = make_redcap_api_payload([data].to_json)
    call_api(redcap_api_payload)
  end
end