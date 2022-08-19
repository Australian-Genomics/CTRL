When('I click the Next button') do
  click_button('Next')
end

Then('I should see default answer to be Not Sure') do
  all_inputs = all('.steps__row input:checked', visible: false)
  expect(all_inputs.map(&:value).uniq).to eq ['not sure']
end
