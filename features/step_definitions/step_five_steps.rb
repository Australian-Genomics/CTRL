When(/I click the first radio button/) do
  first('.controls__radio').click
end

Then(/the first radio button should be selected/) do
  first_radio_button_matching_text = first(
    '.controls__radio input',
    visible: false
  )
  expect(first_radio_button_matching_text).to be_checked
end
