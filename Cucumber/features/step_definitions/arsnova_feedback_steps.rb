#ermoeglicht das Nutzen von httparty vergleichbar wie include in java
require 'httparty'
require 'json'

# anlegen einer neuen class und bekommt sämtliche eigenschaften von HTTParty
# lediglich no_follow wird mit true ueberschrieben
# verhindert das redirect nach einem request
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

When (/^I give bad feedback for the session$/) do
# 4 feedback classes [very good, good, medium, bad] bad equals 3
  @response = HTTParty.post("http://localhost:8080/arsnova-war/session/"+ @sessionid+"/feedback",
    :body => "3",
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
end

Then (/^my feedback should be bad$/) do
# 4 feedback classes [very good, good, medium, bad] bad equals 3
  @response = HTTParty.get("http://localhost:8080/arsnova-war/session/"+ @sessionid+"/myfeedback",
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
  @response.body.should == "3"
end

Then (/^My session should have one bad feedback$/) do
# 4 feedback classes [very good, good, medium, bad]
# cookie is not required in this case  
  session = JSON.parse(@response.body)
  session["values"].should == [0,0,0,1]
end

When (/^I give good feedback once$/) do
# 4 feedback classes [very good, good, medium, bad] good equals 1
  @response = HTTParty.post("http://localhost:8080/arsnova-war/session/"+ @sessionid+"/feedback",
    :body => "1",
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
end

When (/^I give bad feedback once$/) do
# 4 feedback classes [very good, good, medium, bad] bad equals 3
  @response = HTTParty.post("http://localhost:8080/arsnova-war/session/"+ @sessionid+"/feedback",
    :body => "3",
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie2})
end

Then (/^feebackcount should be two$/) do
# 4 feedback classes [very good, good, medium, bad]
# cookie is not required in this case  
  @response = HTTParty.get("http://localhost:8080/arsnova-war/session/"+ @sessionid+"/feedbackcount",
  :headers => { 'Content-Type' => 'text/plain'})
  @response.body.should == "2"
end


Then (/^the session should have a bad and a good feedback$/) do
# 4 feedback classes [very good, good, medium, bad]
# cookie is not required in this case  
  @response = HTTParty.get("http://localhost:8080/arsnova-war/session/"+ @sessionid+"/feedback",
  :headers => { 'Content-Type' => 'text/plain'})
  session = JSON.parse(@response.body)
  session["values"].should == [0,1,0,1]
end

Then (/^the average feedback should be medium$/) do
# one good(1) and one bad(3) feedback 
# cookie is not required in this case  
  @response = HTTParty.get("http://localhost:8080/arsnova-war/session/"+ @sessionid+"/averagefeedback",
  :headers => { 'Content-Type' => 'text/plain'})
  @response.body.should == "2.0"
end


Then (/^the rounded average feedback should be medium$/) do
# one good(1) and one bad(3) feedback 
# cookie is not required in this case 
  @response = HTTParty.get("http://localhost:8080/arsnova-war/session/"+ @sessionid+"/roundedaveragefeedback",
  :headers => { 'Content-Type' => 'text/plain'})
  @response.body.should == "2"
end
