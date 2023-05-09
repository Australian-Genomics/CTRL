class ParticipantIdFormat < ApplicationRecord
  validates :participant_id_format, presence: true
  validate :participant_id_format_already_present
  validate :participant_id_format_is_valid_regexp

  def participant_id_format_already_present
    errors.add(:participant_id_format, 'only one participant ID format can be added') if new_record? && ParticipantIdFormat.count == 1
  end

  def participant_id_format_is_valid_regexp
    Regexp.new(participant_id_format)
  rescue RegexpError => e
    errors.add(
      :participant_id_format,
      "participant ID format must be a valid regular expression; #{e.message}"
    )
  end
end
