When('I click on Review Answers') do
  click_link('Review Answers')
end

When('I click on Confirm') do
  click_link('Confirm')
end

Then('I should be on the confirm answers page') do
  expect(page).to have_link('Confirm')
  expect(page).to have_link('Review Answers')
end

Then('I should see the step three of the consent') do
  visit 'step_three'
end
