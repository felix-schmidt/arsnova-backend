$questionJson = {
  :type => 'skill_question',
  :questionType => 'mc',
  :sessionKeyword => '' , 
  :subject => 'TEST', 
  :text => 'testthema' , 
  :active => 1,
  :number => 0,
  :releasedFor => 'all',
  :possibleAnswers => [{:text => 'answer1', :correct => true},
                      {:text => 'answer2', :correct => false}],
  :abstention => true,
  :showStatistic => 0
}

$questionString = "questionType\":\"mc\",\"sessionKeyword\":\" + @sessionid + \",\"subject\":\"TEST\",\"text\":\"testthema\",\"active\":1,\"number\":0,\"releasedFor\":\"all\",\"possibleAnswers\":[{\"text\":\"answer1\",\"correct\":true},{\"text\":\"answer2\",\"correct\":false}],\"abstention\":true,\"showStatistic\":1}"

When /^create a new lecturer question$/ do
  $questionJson['sessionKeyword'] = @sessionid
    @response = HTTParty.post($serverurl + "/session/" + @sessionid + "/question/",
    :body => $questionJson.to_json,
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
  
  @response.code.should == 201
  @questionid = JSON.parse(@response.body)["_id"]
end

Then /^I should get my lecturer question$/ do
  jsonObject = JSON.parse(@response.body)
  jsonObject["subject"].should == "TEST"
  jsonObject["sessionKeyword"].should == @sessionid
  jsonObject["text"].should == "testthema"
end

When /^delete my new lecturer question$/ do
   @response = HTTParty.delete($serverurl + "/session/" + @sessionid + "/question/" + @questionid,
    :headers => { 'Content-Type' => 'text/plain', 'Cookie' => $cookie})
   @response.code.should == 200
end

When /^I retrieve my lecturer question information$/ do
  @response = HTTParty.get($serverurl + "/session/" + @sessionid + "/question/" + @questionid,
    :headers => { 'Content-Type' => 'text/plain', 'Cookie' => $cookie})
end

Then /^My lecturer question should no longer be available$/ do
  @response.code.should_not == 200
end

When /^change the title to test$/ do
  jsonObject = JSON.parse(@response.body)
  jsonObject["subject"] = "test"
    @response = HTTParty.put($serverurl + "/session/" + @sessionid + "/question/" + @questionid,
    :body => jsonObject.to_json,
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
  #api specifies response code 204 but arsnova returns 200
  #@response.code.should == 204
  @response.code.should == 200
end

Then /^the title should be test$/ do
  jsonObject = JSON.parse(@response.body)
  jsonObject["subject"].should == "test"
  jsonObject["sessionKeyword"].should == @sessionid
  jsonObject["text"].should == "testthema"
end

When /^answer that question$/ do
  @response = Connection.getUserInformation $cookie
  username = JSON.parse(@response.body)["username"]
  @response = HTTParty.post($serverurl + "/session/" + @sessionid + "/question/" + @questionid + "/answer/",
    :body => {
    	:type => "skill_question_answer",
		  :sessionId	=> @sessionid,
		  :questionId => @questionid,
		  :answerText => "1,0",
		  :answerSubject => nil,
		  :user => username,
		  :answerCount => 1,
		  :abstention => false,
		  :abstentionCount => 0
    }.to_json,
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
  @response.code.should == 200
  @answerid = JSON.parse(@response.body)["_id"]

end

Then /^My answer should be added$/ do
  @response.code.should == 200
  jsonObject = JSON.parse(@response.body)
  jsonObject["answerText"].should == "1,0"
end

When /^retrieve a list of answers$/ do
   @response = HTTParty.get($serverurl + "/session/" + @sessionid + 
    "/question/" + @questionid + "/answer/",
    :headers => { 'Content-Type' => 'text/plain', 'Cookie' => $cookie})
   @response.code.should == 200
end

Then /^I should get one answer$/ do
  @response.code.should == 200
  jsonObject = JSON.parse(@response.body)
  jsonObject[0]["answerText"].should == "1,0"
end

When /^delete all answers$/ do
   @response = HTTParty.delete($serverurl + "/session/" + @sessionid + 
    "/question/" + @questionid + "/answer/",
    :headers => { 'Content-Type' => 'text/plain', 'Cookie' => $cookie})
   @response.code.should == 200
end

Then /^I should get no answer$/ do
  @response.code.should == 200
  jsonObject = JSON.parse(@response.body)
  jsonObject.count.should == 0
end

When /^delete my answer$/ do
   @response = HTTParty.delete($serverurl + "/session/" + @sessionid + 
    "/question/" + @questionid + "/answer/" + @answerid,
    :headers => { 'Content-Type' => 'text/plain', 'Cookie' => $cookie})
   @response.code.should == 200
end

When /^change my answer$/ do
    jsonObject = JSON.parse(@response.body)
  	jsonObject["answerText"] = "0,1"
    @response = HTTParty.put($serverurl + "/session/" + @sessionid + 
      "/question/" + @questionid + "/answer/" + @answerid,
    :body => jsonObject.to_json,
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
  #api specifies response code 204 but arsnova returns 200
  #@response.code.should == 204
  @response.code.should == 200
end

Then /^my answer should have changed$/ do
  @response.code.should == 200
  jsonObject = JSON.parse(@response.body)
  jsonObject[0]["answerText"].should == "0,1"
end

When /^create a new unpublished lecturer question$/ do
  $questionJson['sessionKeyword'] = @sessionid
  qJson = $questionJson
  qJson['active'] = 0
  @response = HTTParty.post($serverurl + "/session/" + @sessionid + "/question/",
    :body => qJson.to_json,
    :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
  
  @response.code.should == 201
  JSON.parse(@response.body)["active"].should == false
  @questionid = JSON.parse(@response.body)["_id"]
end

When /^publish the question$/ do
  @response = HTTParty.post($serverurl + "/session/" + @sessionid + 
    "/question/" + @questionid + "/publish?publish=true",
    :body => @response.body,
    :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
   @response.code.should == 200
end

Then /^my question should be published$/ do
  @response.code.should == 200
  jsonObject = JSON.parse(@response.body)
  #jsonObject.count.should_not == 0
  jsonObject["active"].should == true
end

When /^publish the statistic$/ do
  @response = HTTParty.post($serverurl + "/session/" + @sessionid + 
    "/question/" + @questionid + "/publishstatistics?showStatistics=true",
    :body => @response.body,
    :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
   @response.code.should == 200
end

Then /^the statistic of the question should be published$/ do
  @response.code.should == 200
  jsonObject = JSON.parse(@response.body)
  #jsonObject.count.should_not == 0
  jsonObject["showStatistic"].should == true
end

When /^publish the correct answer$/ do
  @response = HTTParty.post($serverurl + "/session/" + @sessionid + 
    "/question/" + @questionid + "/publishcorrectanswer?showCorrectAnswer=true",
    :body => @response.body,
    :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
   @response.code.should == 200
end

Then /^the answer of the question should be published$/ do
  @response.code.should == 200
  jsonObject = JSON.parse(@response.body)
  #jsonObject.count.should_not == 0
  jsonObject["showAnswer"].should == true
end

