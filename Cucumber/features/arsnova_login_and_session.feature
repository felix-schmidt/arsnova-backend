Feature: Hallo Name

  Scenario: Login into arsnova
    Given Arsnova is up and running
    When I login in to arsnova as a guest
    And asking for my user information
    Then I should get my user information
