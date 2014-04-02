Feature: LecturerQuestion

 Scenario: Create lecturequestion
 	Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And create a new lecturer question
    Then I should get my lecturer question
    
Scenario: retrieve lecturer question
 	Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And create a new lecturer question
    And I retrieve my lecturer question information   
    Then I should get my lecturer question 
 
Scenario: Delete lecturequestion
    Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And create a new lecturer question
    And delete my new lecturer question
    And I retrieve my lecturer question information
    Then My lecturer question should no longer be available
    
Scenario: Update lecturer question
 	Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And create a new lecturer question
    And change the title to test
    And I retrieve my lecturer question information
    Then the title should be test
    
Scenario: Answer question
 	Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And create a new lecturer question
    And answer that question
    Then My answer should be added
    
Scenario: Get answer
 	Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And create a new lecturer question
    And answer that question
    And retrieve a list of answers
    Then I should get one answer
    
 Scenario: Delete all answers
 	Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And create a new lecturer question
    And answer that question
    And delete all answers
    And retrieve a list of answers
    Then I should get no answer   
    
 Scenario: Delete my answer
 	Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And create a new lecturer question
    And answer that question
    And delete my answer
    And retrieve a list of answers
    Then I should get no answer
    
 Scenario: Get answer
 	Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And create a new lecturer question
    And answer that question
    And change my answer
    Then my answer should have changed

Scenario: Puplish question
	Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And create a new unpublished lecturer question
    And publish the question
    And I retrieve my lecturer question information
    Then my question should be published
    
Scenario: Puplish statistic
	Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And create a new lecturer question
    And publish the statistic
    And I retrieve my lecturer question information
    Then the statistic of the question should be published

Scenario: Show correct answer
	Given Arsnova is up and running
    When I login in to arsnova as a guest
    And create a new session
    And create a new lecturer question
    And publish the correct answer
    And I retrieve my lecturer question information
    Then the answer of the question should be published
    