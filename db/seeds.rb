consent_steps = Rails.root.join('db', 'seed_data', 'consent_steps.yml')

consent_steps = YAML::load_file(consent_steps)

ConsentStep.create!(consent_steps) do |c|
  puts "Create consent step"
end

4.times do |number|
  ConsentStep.find(number + 1).consent_groups.create(
    order: number + 1
  )
end

ConsentGroup.create(
  order: 5,
  header: 'Who can have access to my de-identified samples and information?'
)

ConsentGroup.create(
  order: 6,
  header: 'What kinds of research can they do with my de-identified samples and information?'
)

ConsentGroup
