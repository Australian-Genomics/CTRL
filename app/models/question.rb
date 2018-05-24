class Question < ApplicationRecord
  has_paper_trail

  belongs_to :step

  enum answer: %w[false true not_sure]

  def checked?(default_value)
    answer.eql?('not_sure') ? default_value : answer.eql?('true')
  end

  def self.get_question_changes_for_last_day
    PaperTrail::Version.where('item_type = ? AND event = ? AND created_at >= ?', 'Question', 'update', 1.day.ago)
  end
end
