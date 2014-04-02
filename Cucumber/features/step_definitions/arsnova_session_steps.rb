When /^create a new session$/ do
  @sessionid, @response = Session.createSession $cookie
end

Then /^I should get a new session$/ do
  @response.code.should == 201
end

Then /^I should get a list of my sessions$/ do
  @response = HTTParty.get($serverurl + "/session/?ownedonly=true",
    :headers => { 'Content-Type' => 'text/plain', 'Cookie' => $cookie})
  jsonObject = JSON.parse(@response.body)
  jsonObject[0]["name"].should == "test"
  jsonObject[0]["keyword"].should == @sessionid
end

When /^I retrieve my session information$/ do
  @response = HTTParty.get($serverurl + "/session/" + @sessionid,
    :headers => { 'Content-Type' => 'text/plain', 'Cookie' => $cookie})
end

Then /^I should get my session information$/ do
  session = JSON.parse(@response.body)
  session["keyword"].should == @sessionid
  session["name"].should == "test"
end

When /^delete my new session$/ do
  @response = HTTParty.delete($serverurl + "/session/" + @sessionid,
    :headers => { 'Content-Type' => 'text/plain', 'Cookie' => $cookie})
end

Then /^My session should no longer be available$/ do
  @response.code.should_not == 200
  @response.body.should == ""
  @sessionid = nil
end

When /^I lock my new session$/ do
  @response = HTTParty.post($serverurl + "/session/" + @sessionid + "/lock?lock=false",
    :headers => { 'Content-Type' => 'text/hmtl', 'Cookie' => $cookie})
  @response.code.should == 200
end



Then /^My session should be locked$/ do
  session = JSON.parse(@response.body)
  session["keyword"].should == @sessionid
  session["active"].should == false
end

When /^unlock my session$/ do
  @response = HTTParty.post($serverurl + "/session/" + @sessionid + "/lock?lock=true",
    :headers => { 'Content-Type' => 'text/hmtl', 'Cookie' => $cookie})
  @response.code.should == 200
end

Then /^my session should be unlocked$/ do
  session = JSON.parse(@response.body)
  session["keyword"].should == @sessionid
  session["active"].should == true
end

When /^change the name to fragestunde$/ do
  session = JSON.parse(@response.body)
  session["name"] = "fragestunde"
  session["name"].should == "fragestunde"
  @response = HTTParty.put($serverurl + "/session/" + @sessionid,
    :body => {:name => 'fragestunde',
              :shortName => 'test'}.to_json,
  :headers => { 'Content-Type' => 'application/json', 'Cookie' => $cookie})
  @response.code.should == 204
end

Then /^the session should be have the name fragestunde$/ do
  session = JSON.parse(@response.body)
  session["keyword"].should == @sessionid
  session["name"].should == "fragestunde"
end

When /^login in to arsnova as a guest2$/ do
  begin
# HTTP request mit der modifizierten HTTParty class
  HTTPartyNoFollow.get($serverurl + "/auth/login?type=guest&role=SPEAKER",
  :headers => { 'Referer' => 'http://localhost:8080/arsnova-war/' })
  rescue HTTParty::RedirectionTooDeep => e 
  e.response.code.should == "302"
# user session id wird in globale variable gespeichert
# wird fast überall genutzt
  $cookie2 = e.response.header['Set-Cookie']
  end
end

When /^retrieve the global session list as user2$/ do
  @response = HTTParty.get($serverurl + "/session/?ownedonly=false",
    :headers => { 'Content-Type' => 'text/plain', 'Cookie' => $cookie2})
  @response.body.should == ""
  #jsonObject = JSON.parse(@response.body)
  #jsonObject[0]["name"].should == "test"
  #jsonObject[0]["keyword"].should == @sessionid
end

When /^delete the foreign session$/ do
  @response = HTTParty.delete($serverurl + "/session/" + @sessionid,
    :headers => { 'Content-Type' => 'text/plain', 'Cookie' => $cookie2})
end

Then /^the session should not be deleted$/ do
  @response.code.should == 200
end