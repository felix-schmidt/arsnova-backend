require 'httparty'

Given(/^Arsnova is up and running$/) do
  @response = HTTParty.get("http://localhost:8080/arsnova-war/",
  :headers => { 'Content-Type' => 'text/plain'})
  @response.code.should == 200
end

When(/^I login in to arsnova as a guest$/) do
  @response = HTTParty.get("http://localhost:8080/arsnova-war/auth/login?type=guest",
  :headers => { 'Referer' => 'http://localhost:8080/arsnova-war/' })  
  puts @response.headers['Set-Cookie']
  puts @response.headers['Content-Type']
  @response.code.should == 200
end

When(/^asking for my information$/) do
   @response = HTTParty.get("http://localhost:8080/arsnova-war/auth/",
  :headers => { 'Content-Type' => 'text/plain', 'Cookie' => 'data'})
  @response.code.should == 200
  puts @response.body
end

Then(/^I should get my information$/) do
  pending # express the regexp above with the code you wish you had
end