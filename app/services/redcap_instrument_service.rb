class RedcapInstrumentService
  attr_accessor :client, :step

  QUESTIONS_REDCAP_FIELDS_HASH = {
    16 => 'ctrl_pref_result1',
    17 => 'ctrl_pref_result2',
    18 => 'ctrl_pref_result3',
    19 => 'ctrl_pref_result4',
    20 => 'ctrl_pref_result5',
    22 => 'ctrl_is_duo_0000028_np',
    23 => 'ctrl_is_duo_0000028_uni',
    24 => 'ctrl_is_duo_0000028_gov',
    25 => 'ctrl_is_duo_0000028_com',
    26 => 'ctrl_gru_cc_duo_0000005',
    27 => 'ctrl_hmb_duo_0000006',
    28 => 'ctrl_ds_duo_0000007',
    29 => 'ctrl_poa_duo_0000011',
    30 => 'ctrl_gso_duo_0000016_gen',
    31 => 'ctrl_gso_duo_0000016_self',
    32 => 'ctrl_samp_data_share11',
    33 => 'ctrl_samp_data_share12'
  }

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
