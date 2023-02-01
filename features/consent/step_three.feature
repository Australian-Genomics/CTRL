Feature: Consent Page
  In order to go through the consent
  A user
  should be able to sign up and go through the step three of the consent

  Scenario: User is not signed up
    Given I do not exist as a user
    And A study code exists
    When I sign in with valid credentials
    Then I see an invalid login message
    And I should not be signed in

  Scenario: User can see the step three page of the consent
    Given I do not exist as a user
    And A study code exists
    When I click on Register
    And I fill in the user details
    Then I should see the step one of consent
    When I click on Next
    Then I should see the step two of the consent
    When I click all the checkboxes
    And I click on Next
    Then I should be on the step three page of consent

  Scenario: User can come back to the step two of the consent
    Given I do not exist as a user
    And A study code exists
    When I click on Register
    And I fill in the user details
    Then I should see the step one of consent
    When I click on Next
    Then I should see the step two of the consent
    When I click all the checkboxes
    And I click on Next
    Then I should be on the step three page of consent
    When I click on Back
    Then I should be on the step two of the consent

  Scenario: User can go to the dashboard page
    Given I do not exist as a user
    And A study code exists
    When I click on Register
    And I fill in the user details
    Then I should see the step one of consent
    When I click on Next
    Then I should see the step two of the consent
    When I click all the checkboxes
    And I click on Next
    Then I should be on the step three page of consent
    When I click all the checkboxes
    And I click on Save and Exit
    Then I should see the dashboard page

  Scenario: User can go to the step four of the consent
    Given I do not exist as a user
    And A study code exists
    When I click on Register
    And I fill in the user details
    Then I should see the step one of consent
    When I click on Next
    Then I should see the step two of the consent
    When I click all the checkboxes
    And I click on Next
    Then I should be on the step three page of consent
    When I click all the checkboxes
    When I click Next
    Then I should see the step four of the consent
