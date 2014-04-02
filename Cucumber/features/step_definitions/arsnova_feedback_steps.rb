#ermoeglicht das Nutzen von httparty vergleichbar wie include in java
require 'httparty'
require 'json'

When (/^I give bad feedback for the session$/) do
# 4 feedback classes [very good, good, medium, bad] bad equals 3
  @response = HTTParty.post($serverurl + "/session/"+ @sessionid+"/feedback",
    :body => "3",
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
end

Then (/^my feedback should be bad$/) do
# 4 feedback classes [very good, good, medium, bad] bad equals 3
  @response = HTTParty.get($serverurl + "/session/"+ @sessionid+"/myfeedback",
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
  @response = HTTParty.post($serverurl + "/session/"+ @sessionid+"/feedback",
    :body => "1",
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
end

When (/^I give bad feedback once$/) do
# 4 feedback classes [very good, good, medium, bad] bad equals 3
  @response = HTTParty.post($serverurl + "/session/"+ @sessionid+"/feedback",
    :body => "3",
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie2})
end

Then (/^feebackcount should be two$/) do
# 4 feedback classes [very good, good, medium, bad]
# cookie is not required in this case  
  @response = HTTParty.get($serverurl + "/session/"+ @sessionid+"/feedbackcount",
  :headers => { 'Content-Type' => 'text/plain'})
  @response.body.should == "2"
end


Then (/^the session should have a bad and a good feedback$/) do
# 4 feedback classes [very good, good, medium, bad]
# cookie is not required in this case  
  @response = HTTParty.get($serverurl + "/session/"+ @sessionid+"/feedback",
  :headers => { 'Content-Type' => 'text/plain'})
  session = JSON.parse(@response.body)
  session["values"].should == [0,1,0,1]
end

Then (/^the average feedback should be medium$/) do
# one good(1) and one bad(3) feedback 
# cookie is not required in this case  
  @response = HTTParty.get($serverurl + "/session/"+ @sessionid+"/averagefeedback",
  :headers => { 'Content-Type' => 'text/plain'})
  @response.body.should == "2.0"
end


Then (/^the rounded average feedback should be medium$/) do
# one good(1) and one bad(3) feedback 
# cookie is not required in this case 
  @response = HTTParty.get($serverurl + "/session/"+ @sessionid+"/roundedaveragefeedback",
  :headers => { 'Content-Type' => 'text/plain'})
  @response.body.should == "2"
end
