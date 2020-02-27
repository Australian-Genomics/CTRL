class RedcapInstrumentService
  attr_accessor :client, :step

  def initialize(step_id)
    @client = RedcapClientService.new
    @step = Step.find(step_id)
  end

  def update
    @client.call(collect_data)
  end

  private

  def collect_data
    data = { 'stud_num' => step.user_study_id }
    step.questions.order(question_id: :asc).each do |quiz|
      next unless QUESTIONS_REDCAP_FIELDS_HASH.key?(quiz.question_id)
      data[QUESTIONS_REDCAP_FIELDS_HASH[quiz.question_id]] = quiz.answer_value
    end
    [data].to_json
  end
end
