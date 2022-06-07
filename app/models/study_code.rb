class StudyCode < ApplicationRecord
    validates :title, presence: true
    validates :title, format: {
        with: /\AA[0-4]{1}[0-9]{1}[2-4]{1}[0-9]{4}\z/,
        message: 'Invalid study code format'
    }, allow_blank: true

    validate :study_code_already_present

    def study_code_already_present
        self.errors.add(:title,"only one study code can be added") if self.new_record? &&  StudyCode.count == 1
    end
end
