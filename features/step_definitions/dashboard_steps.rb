When('I click on the agha logo') do
  find('#header > div > div > div.header__logo-wrapper.col-12.d-flex > a > img').click
end

When("I click on 'Review' for step one") do
  find('body > div > section > div:nth-child(2) > div > div.d-flex.justify-content-end.mnw-120 > a').click
end

When("I click on 'Review' for step two") do
  find('body > div > section > div:nth-child(3) > div > div.d-flex.justify-content-end.mnw-120 > a').click
end

When("I click on 'Review' for step three") do
  find('body > div > section > div:nth-child(4) > div > div.d-flex.justify-content-end.mnw-120 > a').click
end

When("I click on 'Review' for step four") do
  find('body > div > section > div:nth-child(5) > div > div.d-flex.justify-content-end.mnw-120 > a').click
end

When("I click on 'Review' for step five") do
  find('body > div > section > div:nth-child(6) > div > div.d-flex.justify-content-end.mnw-120 > a').click
end

Then('I should see the progress of my current consent step') do
  expect(page).to have_content('Review required')
end

Then('I should see the step one of consent section') do
  expect(page).to have_button('Save and Exit')
  expect(page).to have_content('Watch our short video explaining why we are asking you to provide your consent and are giving you the
              opportunity to update your consent choices online.')
end

Then('I should see the step two of consent section') do
  expect(page).to have_button('Save and Exit')
  expect(page).to have_content('Consent for the genomic test')
end

Then('I should see the step three of consent section') do
  expect(page).to have_button('Save and Exit')
  expect(page).to have_content('Consent to Australian Genomics research participation')
end

Then('I should see the step four of consent section') do
  expect(page).to have_button('Save and Exit')
  expect(page).to have_content('Preferences about your results')
end

Then('I should see the step five of consent section') do
  expect(page).to have_button('Save and Exit')
  expect(page).to have_content('Consent to research outside this study')
end

Then('I should see the dashboard page as step one reviewed') do
  expect(page).to have_content('Reviewed', count: 1)
  expect(page).to have_content('View', count: 1)
end

Then('I should see the dashboard page as step two reviewed') do
  expect(page).to have_content('Reviewed', count: 2)
  expect(page).to have_content('Edit', count: 1)
end

Then('I should see the dashboard page as step three reviewed') do
  expect(page).to have_content('Reviewed', count: 3)
  expect(page).to have_content('Edit', count: 2)
end

Then('I should see the dashboard page as step four reviewed') do
  expect(page).to have_content('Reviewed', count: 4)
  expect(page).to have_content('Edit', count: 3)
end

Then('I should see the dashboard page as step five reviewed') do
  expect(page).to have_content('Reviewed', count: 5)
  expect(page).to have_content('Edit', count: 4)
  expect(page).to_not have_content('Review required')
end
