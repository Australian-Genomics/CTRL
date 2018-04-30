Feature: Consent Page
  In order to go through the consent
  A user
  should be able to sign up and go through the step four of the consent

  Scenario: User is not signed up
    When I sign in with valid credentials
    Then I see an invalid login message
    And I should not be signed in

  Scenario: User can see the step four page of the consent
    When I click on Register
    And I fill in the user details
    Then I should see the step one of consent
    When I click on Next
    Then I should see the step two of the consent
    When I click on Select All
    And I click on Next
    Then I should see the confirm answers page
    And I click on Confirm
    Then I should be on the step three page of consent
    When I click the Next button
    Then I should see the step four of the consent

  Scenario: User can go back to the step three page of the consent
    When I click on Register
    And I fill in the user details
    Then I should see the step one of consent
    When I click on Next
    Then I should see the step two of the consent
    When I click on Select All
    And I click on Next
    Then I should see the confirm answers page
    And I click on Confirm
    Then I should be on the step three page of consent
    When I click the Next button
    Then I should see the step four of the consent
    When I click on Back
    Then I should be on the step three page of consent

  Scenario: User can go to the dashboard page
    When I click on Register
    And I fill in the user details
    Then I should see the step one of consent
    When I click on Next
    Then I should see the step two of the consent
    When I click on Select All
    And I click on Next
    Then I should see the confirm answers page
    And I click on Confirm
    Then I should be on the step three page of consent
    When I click the Next button
    Then I should see the step four of the consent
    When I click on Save and Exit
    Then I should see the dashboard page

  Scenario: User can go to the step five of the consent
    When I click on Register
    And I fill in the user details
    Then I should see the step one of consent
    When I click on Next
    Then I should see the step two of the consent
    When I click on Select All
    And I click on Next
    Then I should see the confirm answers page
    And I click on Confirm
    Then I should be on the step three page of consent
    When I click the Next button
    Then I should see the step four of the consent
    When I click the Next button
    Then I should see the step five of the consent
