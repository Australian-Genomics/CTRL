When('I click on Next') do
  click_link('Next')
end

When('I click on Save and Exit') do
  click_link('Save and Exit')
end

When('I click on Back') do
  click_link('Back')
end

When('I click on Select All') do
  find('#step_two_form > div.d-flex.text-right.mt-3.mb-2.pr-3 > label > span').click
end

When('I click on Unselect All') do
  find(:xpath, "//*[@id='step_two_form']/div[4]/label/span").click
end

When('I click on Next button') do
  find('#step_two_form > div.row.flex-md-row > div.col-6.col-md-3.order-1.order-md-2.d-flex.my-15.my-md-30 > input').click
end

Then('I should see the step one of consent') do
  expect(page).to have_content('Introduction to this platform')
  expect(page).to have_link('Next')
  expect(page).to have_link('Save and Exit')
end

Then('I should see the step two of the consent') do
  expect(page).to have_content('Consent for genomics test')
  expect(page).to have_link('Back')
end

Then('I should come back to the step one') do
  click_link('Back')
end

Then('I should see the dashboard page') do
  expect(page).to have_content('logged in')
end

Then('I should see the confirm answers page') do
  expect(page).to have_content('Confirm')
end

Then('I should see the review answers page') do
  expect(page).to have_content('Review Answers')
end
