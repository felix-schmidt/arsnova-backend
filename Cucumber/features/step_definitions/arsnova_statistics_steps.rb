#ermoeglicht das Nutzen von httparty vergleichbar wie include in java
require 'httparty'
require 'json'

When(/^asking for statistics$/) do
  @response = HTTParty.get($serverurl + "/statistics/",
  :headers => { 'Content-Type' => 'text/plain'})
  @response.code.should == 200
end

Then(/^I should get statistics$/) do
	#check if json contains the following substrings
	@response.body.should include("\"answers\":")
	@response.body.should include("\"questions\":")
	@response.body.should include("\"openSessions\":")
  @response.body.should include("\"closedSessions\":")
	@response.body.should include("\"activeUsers\":")
end