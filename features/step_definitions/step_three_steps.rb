When('I click Next') do
  click_button('Next')
end

Then('I should be on the step three page of consent') do
  expect(page).to have_content('Step 3 of 5')
end

Then('I click on Select All on step three') do
  find('#selectCheckBox15 + span').click
end

Then('I should see the step four of the consent') do
  expect(page).to have_content('Step 4 of 5')
end

Then('I should see the step five of the consent') do
  expect(page).to have_content('Step 5 of 5')
end
