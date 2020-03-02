When('I click on My Personal Details') do
  click_link('My Personal Details')
end

When('I click on My Activities') do
  click_link('My Activities')
end

Then('I click on About') do
  click_link('About')
end

Then('I should see an introduction about the platform') do
  expect(page).to have_content('The Australian Genomics program')
end

Then('I should see the personal details page') do
  expect(page).to have_content('My Personal Details')
end

Then(/^I can see the News and Information link on nav is (active|inactive)$/) do |arg|
  sleep 1
  within(page.all('li.active').first) do
    if arg.eql?('active')
      expect(find('a.nav-link')).to have_content('News and Information')
    else
      expect(find('a.nav-link')).not_to have_content('News and Information')
    end
  end
end
