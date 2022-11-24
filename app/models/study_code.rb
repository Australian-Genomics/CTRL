class StudyCode < ApplicationRecord
    validates :title, presence: true
    validate :study_code_already_present
    validate :study_code_is_valid_regexp

    def study_code_already_present
        self.errors.add(:title, "only one study code can be added") if self.new_record? && StudyCode.count == 1
    end

    def study_code_is_valid_regexp
      begin
        Regexp.new(self.title)
      rescue RegexpError => e
        self.errors.add(
          :title,
          "study code must be a valid regular expression; #{e.message}")
      end
    end
end
