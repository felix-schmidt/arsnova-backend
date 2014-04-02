Feature: Statistics

  Scenario: Statistics request
    Given Arsnova is up and running
    When I login in to arsnova as a guest
    And asking for statistics
    Then I should get statistics
