Feature: InterposedQuestions
 
  Scenario: Create a new interposedQuestion for a session
    Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And I create a new interposedQuestion for the session
    Then I should get the question's data back

  Scenario: Get count of unread interposedQuestion for a session
    Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And I create a new interposedQuestion for the session
    Then the session should have one unread InterposedQuestion
    
   Scenario: Get count of interposedQuestion for a session
    Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And I create a new interposedQuestion for the session
    Then the session should have one InterposedQuestion
    
  Scenario: Get all interposedQuestion for a session
    Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And I create a new interposedQuestion for the session
    And I create another new interposedQuestion for the session
    Then I should get a list of two InterposedQuestion
    
  Scenario: Get a certain interposedQuestion by ID
    Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And I create a new interposedQuestion for the session
    Then I should get this question by ID

  Scenario: Delete a certain interposedQuestion by ID
    Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And I create a new interposedQuestion for the session
    And I delete this interposedQuestion 
    Then there should be no question anymore
    

    
