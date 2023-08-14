class Study < ApplicationRecord
  has_many :study_users, dependent: :destroy
  has_many :users, through: :study_users

  has_many :consent_steps, dependent: :destroy
  has_many :glossary_entries, dependent: :destroy
  has_many :api_users, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validate :participant_id_format_is_valid_regexp

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name participant_id_format]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[api_users consent_steps glossary_entries study_users users]
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
