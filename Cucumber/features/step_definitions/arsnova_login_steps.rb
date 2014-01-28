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

When(/^asking for my user information$/) do
  @response = HTTParty.get("http://localhost:8080/arsnova-war/auth/",
  :headers => { 'Content-Type' => 'text/plain', 'Cookie' => $cookie})
  @response.code.should == 200
end

Then(/^I should get my user information$/) do
	#prüft ob json string genau diese substrings enhaelt
	@response.body.should include("\"username\":")
	@response.body.should include("\"type\":")
	@response.body.should include("\"role\":")
end


