class StudyCode < ApplicationRecord
    validates :title, presence: true

    validate :study_code_already_present

    def study_code_already_present
        self.errors.add(:title,"only one study code can be added") if StudyCode.count == 1
    end
end
