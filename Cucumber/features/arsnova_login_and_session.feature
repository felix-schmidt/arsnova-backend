Feature: Login and Session

  Scenario: Login into arsnova
    Given Arsnova is up and running
    When I login in to arsnova as a guest
    And asking for my user information
    Then I should get my user information

  Scenario: Session create
    Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    Then I should get a new session

  Scenario: retrieve Session list for active u
    Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And I should get a new session
    Then I should get a list of my sessions

  Scenario: Session information retrieval
    Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And I retrieve my session information
    Then I should get my session information

  Scenario: Delete a session
    Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And delete my new session
    And I retrieve my session information
    Then My session should no longer be available

  Scenario: Lock a session
    Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And I lock my new session
    And I retrieve my session information
    Then My session should be locked

  Scenario: Unlock a session
    Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And I lock my new session
    And unlock my session
    And I retrieve my session information
    Then my session should be unlocked

  #Scenario: Update a session
    #Given Arsnova is up and running
    #When I login in to arsnova as a guest
    #And create a new session
    #And change the name to fragestunde 
    #And I retrieve my session information
    #Then the session should be have the name fragestunde
    
 Scenario: Delete foreign user session
    Given Arsnova is up and running
    When I login in to arsnova as a guest
    And login in to arsnova as a guest2
    And create a new session
    And retrieve the global session list as user2
    And delete the foreign session
    And I retrieve my session information
    Then the session should not be deleted
