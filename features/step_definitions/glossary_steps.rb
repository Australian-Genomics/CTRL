def assert_glossary_page(page)
  expect(page).to have_content('Glossary')

  expect(page).to have_content('DNA')
  expect(page).to have_content('noun')

  expect(page).to have_content('Genetic')
  expect(page).to have_content('adjective')
end

Then('I should see the glossary page') do
  assert_glossary_page(page)
end

Then('I should see the glossary page opened in a new tab') do
  within_window(windows.last) do
    assert_glossary_page(page)
  end
end
