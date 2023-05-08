Feature: Modal Fallback
  The modal fallback pop-up displays when some checkbox agreement elements
  are set to 'no' (i.e. unchecked).

  Scenario: User sees the modal fallback when some checkbox agreement elements aren't checked
    Given I do not exist as a user
    And A participant ID format exists
    When I click on Register
    And I fill in the user details
    Then I should see the step one of consent
    When I click on Next
    Then I should see the step two of the consent
    When I click all the checkboxes
    And I click the last checkbox
    And I click on Next
    Then I should see the modal fallback

