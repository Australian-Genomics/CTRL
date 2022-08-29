class GlossaryEntry < ApplicationRecord
  validates :term, :definition, presence: true
end
