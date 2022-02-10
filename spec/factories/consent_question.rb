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
          value: 'yes'
        )

        create(
          :question_option,
          consent_question: consent_question,
          value: 'no'
        )
      end
    end

    trait :checkbox do
      question_type { 'checkbox' }
      default_answer 'yes'
    end
  end
end
