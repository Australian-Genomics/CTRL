When('I click Next') do
  click_button('Next')
end

When("I click on I don't want to take part") do
  click_link("I don't want to take part")
end

Then('I should be on the step three page of consent') do
  expect(page).to have_content('Step 3 of 5')
end

Then('I should see the notification consent page') do
  expect(page).to have_link('Return to Dashboard')
end

Then('I should see the step four of the consent') do
  expect(page).to have_content('Step 4 of 5')
end

Then('I should see the step five of the consent') do
  expect(page).to have_content('Step 5 of 5')
end
