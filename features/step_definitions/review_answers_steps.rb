When("I click on I don't want the test") do
  click_link("I don't want the test")
end

When('I click on Return to Dashboard') do
  click_link('Return to Dashboard')
end

Then('I should be on the review answers page') do
  expect(page).to have_link("I don't want the test")
  expect(page).to have_link('Review Answers')
end

Then('I should be on the notification consent page') do
  expect(page).to have_link('Return to Dashboard')
end
