class GlossaryEntry < ApplicationRecord
  validates :term, :definition, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "definition", "id", "study_id", "term", "updated_at"]
  end
end
