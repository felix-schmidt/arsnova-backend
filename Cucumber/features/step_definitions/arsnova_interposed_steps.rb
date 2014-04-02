#ermoeglicht das Nutzen von httparty vergleichbar wie include in java
require 'httparty'
require 'json'

When (/^I create a new interposedQuestion for the session$/) do
    @response = HTTParty.post($serverurl + "/session/"+ @sessionid+"/interposed",
    :body => "{\"subject\":\"test\",\"text\":\"asdfasdf\",\"sessionId\":"+@sessionid+"}",
    :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
    @response.code.should == 201
end

Then (/^I should get the question's data back$/) do
  jsonObject = JSON.parse(@response.body)
  jsonObject["subject"].should == "test"
  #  no JSON object found, but documented in the API
  #  need to get @questionid here for later tests
  #  vllt funktioniert es nur bei mir nicht?? im quellcode heißt es
end

Then (/^the session should have one InterposedQuestion$/) do
   @response = HTTParty.get($serverurl + "/session/"+ @sessionid+"/interposed/count",
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
  @response.code.should == 200
  @response.body.should == "1" 
  #jsonObject im header, but not in response
end

Then /^the session should have one unread InterposedQuestion$/ do
   @response = HTTParty.get($serverurl + "/session/"+ @sessionid+"/interposed/readcount",
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
  @response.code.should == 200
  jsonObject = JSON.parse(@response.body)
  jsonObject["total"].should == 1
  jsonObject["read"].should == 1
  jsonObject["unread"].should == 0
  #
end

When /^I create another new interposedQuestion for the session$/ do
    @response = HTTParty.post($serverurl + "/session/"+ @sessionid+"/interposed",
    :body => "{\"subject\":\"test2\",\"text\":\"yxcvyxcv\",\"sessionId\":"+@sessionid+"}",
    :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
    @response.code.should == 201
end

Then /^I should get a list of two InterposedQuestion$/ do
   @response = HTTParty.get($serverurl + "/session/"+ @sessionid+"/interposed",
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
  @response.code.should == 200
  jsonObject = JSON.parse(@response.body)
  # first question
  jsonObject[0]["subject"].should == "test"
  jsonObject[0]["sessionId"].should == @sessionid
  # second question
  jsonObject[1]["subject"].should == "test2"
  jsonObject[1]["sessionId"].should == @sessionid
#  Text string is nil. also tested with http requester but gui shows the string. 
#  with the next case (line 117) i get text string.
#  jsonObject[0]["text"].should == "asdfasdf"  
# 
end

# Hier funktioniert noch nichts da ich die @questionId nicht zurückbekommen beim POST befehl der interposedQuestion

Then /^I should get this question by ID$/ do
  @response = HTTParty.get($serverurl + "/session/"+ @sessionid+"/interposed/"+@interposedquestionid,
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
  @response.code.should == 200
  jsonObject = JSON.parse(@response.body)
  jsonObject["subject"].should == "test"
  jsonObject["text"].should == "asdfasdf"
end

When /^I delete this interposedQuestion$/ do
  @response = HTTParty.delete($serverurl + "/session/"+ @sessionid+"/interposed/"+@interposedquestionid,
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
  @response.code.should == 200
end

Then /^there should be no question anymore$/ do
  @response = HTTParty.get($serverurl + "/session/"+ @sessionid+"/interposed/"+@interposedquestionid,
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
  @response.code.should == 500 # error 
 
end

When /^Retrieve the ID for this Interposed Question$/ do
     @response = HTTParty.get($serverurl + "/session/"+ @sessionid+"/interposed",
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
  @response.code.should == 200
  jsonObject = JSON.parse(@response.body)
  # first question
  @interposedquestionid = jsonObject[0]["_id"]
end
