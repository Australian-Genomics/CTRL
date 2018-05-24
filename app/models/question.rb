class Question < ApplicationRecord
  has_paper_trail

  belongs_to :step

  enum answer: %w[false true not_sure]

  def checked?(default_value)
    answer.eql?('not_sure') ? default_value : answer.eql?('true')
  end

  def self.question_changes_for_last_day
    today_in_zone = Timezone['Australia/Melbourne'].time_with_offset(Time.now)
    start_of_day = (today_in_zone - 1.day).beginning_of_day
    end_of_day = (today_in_zone - 1.day).end_of_day
    PaperTrail::Version.where('item_type = ? AND event = ? AND created_at >= ? AND created_at < ?', 'Question', 'update', start_of_day, end_of_day)
  end
end
