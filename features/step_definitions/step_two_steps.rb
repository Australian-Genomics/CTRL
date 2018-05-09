When('I click on Save and Exit') do
  click_button('Save and Exit')
end

When('I click on Back') do
  click_link('Back')
end

When('I click on Select All') do
  find('#controlsSelectAll + span').click
end

When('I click on Unselect All') do
  find('#controlsUnselectAll + span').click
end

Then('I should see the step one of consent') do
  expect(page).to have_content('Step 1 of 5')
  expect(page).to have_button('Next')
  expect(page).to have_button('Save and Exit')
end

Then('I should see the step two of the consent') do
  expect(page).to have_content('Step 2 of 5')
  expect(page).to have_link('Back')
end

Then('I should come back to the step one') do
  click_link('Back')
end

Then('I should see the dashboard page') do
  expect(page).to have_link('Log Out')
end

Then('I should see the confirm answers page') do
  expect(page).to have_content('Confirm')
end

Then('I should see the review answers page') do
  expect(page).to have_content('Review Answers')
end
