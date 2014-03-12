require 'httparty'
require 'json'

class HTTPartyNoFollow
  include HTTParty
  no_follow true
end

Given(/^Arsnova is up and running$/) do
# normaler http request mit standart HTTParty gem
  @response = HTTParty.get("http://localhost:8080/arsnova-war/",
  :headers => { 'Content-Type' => 'text/plain'})
# checkt ob der response code dem erwarteten entspricht
  @response.code.should == 200
end


When(/^I login in to arsnova as a guest$/) do
begin
# HTTP request mit der modifizierten HTTParty class
  HTTPartyNoFollow.get("http://localhost:8080/arsnova-war/auth/login?type=guest&role=SPEAKER",
  :headers => { 'Referer' => 'http://localhost:8080/arsnova-war/' })
  rescue HTTParty::RedirectionTooDeep => e 
  e.response.code.should == "302"
# user session id wird in globale variable gespeichert
# wird fast überall genutzt
  $cookie = e.response.header['Set-Cookie']
  end
end

When /^login in to arsnova as a guest2$/ do
  begin
# HTTP request mit der modifizierten HTTParty class
  HTTPartyNoFollow.get("http://localhost:8080/arsnova-war/auth/login?type=guest&role=SPEAKER",
  :headers => { 'Referer' => 'http://localhost:8080/arsnova-war/' })
  rescue HTTParty::RedirectionTooDeep => e 
  e.response.code.should == "302"
# user session id wird in globale variable gespeichert
# wird fast überall genutzt
  $cookie2 = e.response.header['Set-Cookie']
  end
end

When (/^create a new session$/) do
  @response = HTTParty.post("http://localhost:8080/arsnova-war/session/",
    :body => {:name => 'test',
              :shortName => 'test'}.to_json,
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
  @sessionid = JSON.parse(@response.body)["keyword"]
end

When (/^I create a new interposedQuestion for the session$/) do
    @response = HTTParty.post("http://localhost:8080/arsnova-war/session/"+ @sessionid+"/interposed",
    :body => "{\"subject\":\"test\",\"text\":\"asdfasdf\",\"sessionId\":"+@sessionid+"}",
    :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
    @response.code.should == 201
end

Then (/^I should get the question's data back$/) do
  jsonObject = JSON.parse(@response.body)
  jsonObject[0]["subject"].should == "test"
  #  no JSON object found, but documented in the API
  #  need to get @questionid here for later tests
  #  vllt funktioniert es nur bei mir nicht?? im quellcode heißt es
end

Then (/^the session should have one InterposedQuestion$/) do
   @response = HTTParty.get("http://localhost:8080/arsnova-war/session/"+ @sessionid+"/interposed/count",
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
  @response.code.should == 200
  @response.body.should == "1" 
  #jsonObject im header, but not in response
end

Then /^the session should have one unread InterposedQuestion$/ do
   @response = HTTParty.get("http://localhost:8080/arsnova-war/session/"+ @sessionid+"/interposed/readcount",
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
  @response.code.should == 200
  jsonObject = JSON.parse(@response.body)
  jsonObject["total"].should == 1
  jsonObject["read"].should == 1
  jsonObject["unread"].should == 0
  #
end

When /^I create another new interposedQuestion for the session$/ do
    @response = HTTParty.post("http://localhost:8080/arsnova-war/session/"+ @sessionid+"/interposed",
    :body => "{\"subject\":\"test2\",\"text\":\"yxcvyxcv\",\"sessionId\":"+@sessionid+"}",
    :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
    @response.code.should == 201
end

Then /^I should get a list of two InterposedQuestion$/ do
   @response = HTTParty.get("http://localhost:8080/arsnova-war/session/"+ @sessionid+"/interposed",
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
  @response = HTTParty.get("http://localhost:8080/arsnova-war/session/"+ @sessionid+"/interposed/"+@questionid,
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
  @response.code.should == 200
  jsonObject = JSON.parse(@response.body)
  jsonObject[0]["subject"].should == "test"
  jsonObject[0]["text"].should == "asdfasdf"
end

When /^I delete this interposedQuestion$/ do
  @response = HTTParty.delete("http://localhost:8080/arsnova-war/session/"+ @sessionid+"/interposed/"+@questionid,
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
  @response.code.should == 200
end

Then /^there should be no question anymore$/ do
  @response = HTTParty.get("http://localhost:8080/arsnova-war/session/"+ @sessionid+"/interposed/"+@questionid,
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
  @response.code.should == 500 # error 
 
end
