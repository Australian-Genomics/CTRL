Feature: Consent Page
  In order to go through the consent
  A user
  should be able to sign up and go through the steps

  Scenario: User is not signed up
    Given I do not exist as a user
    When I request an OTP
    Then I see an invalid login message
    And I should not be signed in

  Scenario: User signs up successfully
    Given I do not exist as a user
    When I click on Register
    And I fill in the user details
    Then I should be on the step one of consent

  Scenario: User can go to the step two of the consent
    Given I do not exist as a user
    When I click on Register
    And I fill in the user details
    Then I should be on the step one of consent
    When I click on Next
    Then I should be on the step two of the consent
    And I should come back to the step one page
    When I click on link Save and Exit
    Then I should the dashboard page
