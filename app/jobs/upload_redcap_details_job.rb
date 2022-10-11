class UploadRedcapDetailsJob < ApplicationJob
  queue_as :redcap_upload

  # TODO: Make sure POSTing doesn't affect responsiveness/speed of the form
  # TODO: Write tests

  # TODO: These should be read at the program's entrypoint
  @@token = ENV['REDCAP_TOKEN']
  @@api_url = ENV['REDCAP_URL']
  @@connection_enabled = ActiveModel::Type::Boolean.new.cast(ENV['REDCAP_CONNECTION_ENABLED'] || 'false')

  # TODO: Get rollbar token
  def call_api(payload)
    if !@@connection_enabled
      logger.info("Connection disabled; not posting payload: #{payload}")
      return true
    end

    begin
      response = HTTParty.post(@@api_url, body: payload)
      logger.info("Posted payload: #{payload}")
      response.success? && response.parsed_response['count'] == 1
    rescue HTTParty::Error, SocketError => e
      msg = "Error connecting to RedCap - #{e.message}"
      logger.error(msg)
      Rollbar.error(msg)
      false
    end
  end

  def make_redcap_api_payload(data)
    data.nil? ? nil : {
      token: @@token,
      content: 'record',
      format: 'json',
      type: 'flat',
      data: data
    }
  end

  def fetch_redcap_code(consent_question, answer)
    pp 'ASDF' # TODO
    pp answer # TODO
    redcap_code = consent_question
      .question_options
      .where('LOWER(value) = ?', answer)
      .first
      &.redcap_code
    pp redcap_code # TODO
    if redcap_code.nil?
      redcap_code = case answer
        when 'yes' then '1'
        when 'no' then '0'
        else nil
      end
    end
    redcap_code
  end

  def collect_data(question_answer_id, destroy)
    question_answer = QuestionAnswer.find(question_answer_id)
    if question_answer.nil?
      logger.info "Question answer not found with id=#{question_answer_id}"
      return
    end

    redcap_code = fetch_redcap_code(
      question_answer.consent_question,
      question_answer.answer
    )

    consent_question = question_answer.consent_question
    redcap_field = consent_question.redcap_field

    if redcap_field.blank?
      logger.info "Redcap field blank for question answer with id=#{question_answer_id}"
      return
    end

    if consent_question.question_type == "multiple checkboxes"
      redcap_field = "#{redcap_field}___#{redcap_code}"
      redcap_code = destroy ? '0' : '1'
    end

    data = {
      'record_id' => question_answer.user_id,
      redcap_field => redcap_code,
    }

    [data].to_json
  end

  def perform(question_answer_id, destroy=false)
    logger.info "Performing upload job for question with id=#{question_answer_id}"
    data = collect_data(question_answer_id, destroy)
    redcap_api_payload = make_redcap_api_payload(data)
    if redcap_api_payload.nil?
      logger.info "Payload empty; Not posting for question with id=#{question_answer_id}"
      return
    end
    call_api(redcap_api_payload)
  end
end
