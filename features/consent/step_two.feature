Feature: Consent Page
  In order to go through the consent
  A user
  should be able to sign up and go through the steps

  Scenario: User is not signed up
    Given I do not exist as a user
    When I sign in with valid credentials
    Then I see an invalid login message
    And I should not be signed in

  Scenario: User can see the step two page of the consent
    Given I do not exist as a user
    When I click on Register
    And I fill in the user details
    Then I should see the step one of consent
    When I click on Next
    Then I should see the step two of the consent

  Scenario: User can come back to the step one of the consent
    Given I do not exist as a user
    When I click on Register
    And I fill in the user details
    Then I should see the step one of consent
    When I click on Next
    Then I should see the step two of the consent
    When I click on Back
    Then I should see the step one of consent

  Scenario: User can save and go to the dashboard page
    Given I do not exist as a user
    When I click on Register
    And I fill in the user details
    Then I should see the step one of consent
    When I click on Next
    Then I should see the step two of the consent
    When I click all the checkboxes
    And I click on Save and Exit
    Then I should see the dashboard page
