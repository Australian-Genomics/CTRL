class SurveyConfig < ApplicationRecord
  after_create :set_key
  scope :get_config, ->(key) { where('key = ? ', key) }

  def set_key
    update(key: snakecase(name))
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at hint id is_file key name updated_at value]
  end

  private

  def snakecase(string)
    # gsub(/::/, '/').
    string.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .tr('-', '_')
          .gsub(/\s/, '_')
          .gsub(/__+/, '_')
          .downcase
  end
end
