class GlossaryEntry < ApplicationRecord
  validates :term, :definition, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at definition id study_id term updated_at]
  end
end
