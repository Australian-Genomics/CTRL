class ParticipantIdFormat < ApplicationRecord
  validates :participant_id_format, presence: true
  validate :participant_id_format_already_present
  validate :participant_id_format_is_valid_regexp

  def participant_id_format_already_present
    self.errors.add(:participant_id_format, "only one participant ID format can be added") if self.new_record? && ParticipantIdFormat.count == 1
  end

  def participant_id_format_is_valid_regexp
    begin
      Regexp.new(self.participant_id_format)
    rescue RegexpError => e
      self.errors.add(
        :participant_id_format,
        "participant ID format must be a valid regular expression; #{e.message}")
    end
  end
end
