class Question < ApplicationRecord
  has_paper_trail

  belongs_to :step

  enum answer: %w[false true not_sure]

  def check_box_checked?(default_value)
    answer ? answer.eql?('true') : default_value
  end

  def radio_button_checked?(default_value)
    if answer
      return answer if answer.eql?('not_sure')
      answer.eql?('true')
    else
      default_value
    end
  end

  def self.question_changes_for_last_day
    today_in_zone = Timezone['Australia/Melbourne'].time_with_offset(Time.now)
    start_of_day = (today_in_zone - 1.day).beginning_of_day
    end_of_day = (today_in_zone - 1.day).end_of_day
    Question.left_outer_joins(:versions, step: :user)
        .select("users.study_id, users.email, (steps.number) AS step_number, questions.id, questions.question_id")
        .group('users.study_id, users.email, step_number, questions.id, questions.question_id')
        .where("versions.event IN (?) AND versions.created_at >= ? AND versions.created_at < ?", %w[create update], start_of_day, end_of_day)
  end

  def answer_value
    Question.answers[answer]
  end
end
