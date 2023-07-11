Feature: Glossary
  Scenario: User can access glossary from the dashboard
    Given I exist as a user
    And I am not logged in
    When I sign in with valid credentials
    Then I should be signed in
    And I should see the dashboard page
    When I click the link 'Glossary'
    Then I should see the glossary page

  Scenario: User can access the glossary from terms which link to it
    Given I do not exist as a user
    When I click on Register
    And I fill in the user details
    Then I should see the step one of consent
    When I click on Next
    Then I should see the step two of the consent
    When I click the link 'DNA'
    Then I should see the glossary page opened in a new tab
