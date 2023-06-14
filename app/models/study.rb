class Study < ApplicationRecord
  has_many :user_studies, dependent: :destroy
  has_many :users, through: :user_studies

  validates :name, presence: true, uniqueness: true
  validate :participant_id_format_is_valid_regexp

  def participant_id_format_is_valid_regexp
    Regexp.new(participant_id_format)
  rescue RegexpError => e
    errors.add(
      :participant_id_format,
      "participant ID format must be a valid regular expression; #{e.message}"
    )
  end
end

