Feature: Feedback
 
  Scenario: Give feedback for a session
    Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And I give bad feedback for the session
    Then My session should have one bad feedback

  Scenario: Get my feedback for a session
    Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And I give bad feedback for the session
    Then my feedback should be bad

  Scenario: Get feedbackcount for a session
    Given Arsnova is up and running
    When I login in to arsnova as a guest
    And login in to arsnova as a guest2
    And create a new session
    And I give good feedback once
    And I give bad feedback once
    Then feebackcount should be two

  Scenario: Get feedbackcount for a session
    Given Arsnova is up and running
    When I login in to arsnova as a guest
    And login in to arsnova as a guest2
    And create a new session
    And I give good feedback once
    And I give bad feedback once
    Then the session should have a bad and a good feedback

  Scenario: Get average feedback for a session
    Given Arsnova is up and running
    When I login in to arsnova as a guest
    And login in to arsnova as a guest2
    And create a new session
    And I give good feedback once
    And I give bad feedback once
    Then the average feedback should be medium

  Scenario: Get rounded average feedback for a session
    Given Arsnova is up and running
    When I login in to arsnova as a guest
    And login in to arsnova as a guest2
    And create a new session
    And I give good feedback once
    And I give bad feedback once
    Then the rounded average feedback should be medium
