FactoryBot.define do
  factory :consent_question do
    consent_group { create(:consent_group) }

    sequence(:order) { |n| n }

    question { Faker::Lorem.question }
    question_type { 'checkbox' }
    default_answer 'yes'

    description { Faker::Lorem.paragraph }
    answer_choices_position { 'right' }

    trait :multiple_choice do
      question_type { 'multiple choice' }
      default_answer 'yes'

      after(:create) do |consent_question, _evaluator|
        create(
          :question_option,
          consent_question: consent_question,
          value: 'yes',
          redcap_code: '11'
        )

        create(
          :question_option,
          consent_question: consent_question,
          value: 'no',
          redcap_code: '10'
        )
      end
    end

    trait :multiple_checkboxes do
      question_type { 'multiple checkboxes' }
      default_answer 'yes'

      after(:create) do |consent_question, _evaluator|
        create(
          :question_option,
          consent_question: consent_question,
          value: 'yes',
          redcap_code: '11'
        )

        create(
          :question_option,
          consent_question: consent_question,
          value: 'no',
          redcap_code: '10'
        )
      end
    end

    trait :checkbox do
      question_type { 'checkbox' }
      default_answer 'yes'
    end

    trait :with_redcap_field do
      redcap_field 'redcap_field_name'
    end
  end
end
