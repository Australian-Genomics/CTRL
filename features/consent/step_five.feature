Feature: Consent Page
  In order to go through the consent
  A user
  should be able to sign up and go through the step four of the consent

  Scenario: User is not signed up
    Given I do not exist as a user
    When I sign in with valid credentials
    Then I see an invalid login message
    And I should not be signed in

  Scenario: User can see the step five page of the consent
    Given I do not exist as a user
    When I click on Register
    And I fill in the user details
    Then I should see the step one of consent
    When I click on Next
    Then I should see the step two of the consent
    When I click all the checkboxes
    And I click on Next
    Then I should be on the step three page of consent
    When I click all the checkboxes
    When I click the Next button
    Then I should see the step four of the consent
    And I should see default answer to be Not Sure
    When I click the Next button
    Then I should see the step five of the consent
    And I should see default answer to be Not Sure

  Scenario: User can go back to the step four of the consent
    Given I do not exist as a user
    When I click on Register
    And I fill in the user details
    Then I should see the step one of consent
    When I click on Next
    Then I should see the step two of the consent
    When I click all the checkboxes
    And I click on Next
    Then I should be on the step three page of consent
    When I click all the checkboxes
    When I click the Next button
    Then I should see the step four of the consent
    When I click the Next button
    Then I should see the step five of the consent
    When I click on Back
    Then I should see the step four of the consent

  Scenario: Going back to step four saves step five
    Given I do not exist as a user
    When I click on Register
    And I fill in the user details
    Then I should see the step one of consent
    When I click on Next
    Then I should see the step two of the consent
    When I click all the checkboxes
    And I click on Next
    Then I should be on the step three page of consent
    When I click all the checkboxes
    When I click the Next button
    Then I should see the step four of the consent
    When I click the Next button
    Then I should see the step five of the consent
    When I click the first radio button
    And I click on Back
    Then I should see the step four of the consent
    When I click the Next button
    Then I should see the step five of the consent
    And the first radio button should be selected

  Scenario: User can save and go to the dashboard page
    Given I do not exist as a user
    When I click on Register
    And I fill in the user details
    Then I should see the step one of consent
    When I click on Next
    Then I should see the step two of the consent
    When I click all the checkboxes
    And I click on Next
    Then I should be on the step three page of consent
    When I click all the checkboxes
    When I click the Next button
    Then I should see the step four of the consent
    And I should see default answer to be Not Sure
    When I click the Next button
    Then I should see the step five of the consent
    When I click on Save and Exit
    Then I should see the dashboard page
