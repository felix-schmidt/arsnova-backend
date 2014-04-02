#ermoeglicht das Nutzen von httparty vergleichbar wie include in java
require 'httparty'
require 'json'


Given(/^Arsnova is up and running$/) do
  Connection.checkRunning.should == 200
end


When(/^I login in to arsnova as a guest$/) do
begin
  $cookie = Connection.loginAsGuest
  end
end

When(/^asking for my user information$/) do
  @response = Connection.getUserInformation $cookie
  @response.code.should == 200
end

Then(/^I should get my user information$/) do
	#parsed den json string
	parsedString = JSON.parse(@response.body)
	puts 
	#prüft ob json string genau diese substrings enhaelt
	@response.body.should include("\"username\":")
	@response.body.should include("\"type\":")
	@response.body.should include("\"role\":")
	
	#parsedString["type"].should_not == nil
end

