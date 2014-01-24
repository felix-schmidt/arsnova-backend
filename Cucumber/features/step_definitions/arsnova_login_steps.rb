require 'httparty'

$cookie

class HTTPartyNoFollow
  include HTTParty
  no_follow true
end

Given(/^Arsnova is up and running$/) do
  @response = HTTParty.get("http://localhost:8080/arsnova-war/",
  :headers => { 'Content-Type' => 'text/plain'})
  @response.code.should == 200
end

When(/^I login in to arsnova as a guest$/) do
begin
  HTTPartyNoFollow.get("http://localhost:8080/arsnova-war/auth/login?type=guest",
  :headers => { 'Referer' => 'http://localhost:8080/arsnova-war/' })
  rescue HTTParty::RedirectionTooDeep => e 
  e.response.code.should == "302"
  $cookie = e.response.header['Set-Cookie']
  end
end

When(/^asking for my information$/) do
  @response = HTTParty.get("http://localhost:8080/arsnova-war/auth/",
  :headers => { 'Content-Type' => 'text/plain', 'Cookie' => $cookie})
  @response.code.should == 200
  puts @response.body
end

Then(/^I should get my information$/) do
end


