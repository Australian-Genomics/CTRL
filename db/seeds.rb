unless AdminUser.find_by(email: 'adminuser@email.com')
  AdminUser.create(
    email: 'adminuser@email.com',
    password: 'tester123',
    password_confirmation: 'tester123'
  )

  puts 'created admin user email: adminuser@email.com, password is tester123'
end

unless User.find_by(email: 'testuser@email.com')
  User.create(
    email: 'testuser@email.com',
    password: 'tester123',
    password_confirmation: 'tester123',
    study_id: 'A1543457',
    first_name: 'testser',
    family_name: 'familyOfUser',
    dob: 10.years.ago
  )

  puts 'created user created: testuser@email.com, password is tester123'
end

consent_steps = Rails.root.join('db', 'seed_data', 'consent_steps.yml')

return unless ConsentStep.count.zero?

consent_steps = YAML::load_file(consent_steps)
ConsentStep.create!(consent_steps)

puts 'Steps 1 to 5 created'

# Step two

step_two_questions = Rails.root.join('db', 'seed_data', 'step_two_questions.yml')
step_two_questions = YAML::load_file(step_two_questions)

ConsentStep.second.consent_groups.create(
  header: '',
  order: 1
).consent_questions.create!(step_two_questions)

step_two_modal_fallback = Rails.root.join('db', 'seed_data', 'step_two_modal_fallback.yml')
step_two_modal_fallback = YAML::load_file(step_two_modal_fallback)

ConsentStep.second.modal_fallbacks.create!(step_two_modal_fallback)

puts 'Step 2 questions created'

# Step three

step_three_questions = Rails.root.join('db', 'seed_data', 'step_three_questions.yml')
step_three_questions = YAML::load_file(step_three_questions)

ConsentStep.third.consent_groups.create(
  header: '',
  order: 1
).consent_questions.create!(step_three_questions)

step_three_modal_fallback = Rails.root.join('db', 'seed_data', 'step_three_modal_fallback.yml')
step_three_modal_fallback = YAML::load_file(step_three_modal_fallback)

ConsentStep.third.modal_fallbacks.create!(step_three_modal_fallback)

puts 'Step 3 questions created'

# Step four

step_four_questions = Rails.root.join('db', 'seed_data', 'step_four_questions.yml')
step_four_questions = YAML::load_file(step_four_questions)

ConsentStep.fourth.consent_groups.create(
  header: '',
  order: 1
).consent_questions.create!(step_four_questions)

ConsentStep
  .fourth
  .consent_groups
  .first
  .consent_questions
  .where(question_type: 'multiple choice')
  .each do |consent_question|
  consent_question.question_options.create!(
    value: 'yes'
  )
  consent_question.question_options.create!(
    value: 'no'
  )
  consent_question.question_options.create!(
    value: 'not sure'
  )
end

puts 'Step 4 questions created'

# Step five

step_five_part_one = Rails.root.join('db', 'seed_data', 'step_five_part_one_questions.yml')
step_five_part_one = YAML::load_file(step_five_part_one)

ConsentStep.fifth.consent_groups.create(
  header: 'Who can have access to my de-identified samples and information?',
  order: 1,
).consent_questions.create!(step_five_part_one)

ConsentStep.fifth
  .consent_groups
  .first
  .consent_questions
  .where(question_type: 'multiple choice').each do |consent_question|
  consent_question.question_options.create!(
    value: 'yes'
  )
  consent_question.question_options.create!(
    value: 'no'
  )
  consent_question.question_options.create!(
    value: 'not sure'
  )
end

puts 'Step 5 part 1 created'

step_five_part_two = Rails.root.join('db', 'seed_data', 'step_five_part_two_questions.yml')
step_five_part_two = YAML::load_file(step_five_part_two)

ConsentStep.fifth.consent_groups.create(
  header: 'What kinds of research can they do with my de-identified samples and information?',
  order: 2,
).consent_questions.create!(step_five_part_two)

ConsentStep.fifth
  .consent_groups
  .second
  .consent_questions
  .where(question_type: 'multiple choice').each do |consent_question|

  consent_question.question_options.create!(
    value: 'yes'
  )
  consent_question.question_options.create!(
    value: 'no'
  )
  consent_question.question_options.create!(
    value: 'not sure'
  )
end

puts 'Step 5 part 2 created'
