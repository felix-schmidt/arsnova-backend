require 'httparty'
require 'json'

$serverurl = "http://localhost:8080/arsnova-war"
$hallo = "hallo"

# monkey patching HttParity class to enable no_follow rule
class HTTPartyNoFollow
  include HTTParty
  no_follow true
end

module Connection
	extend self
 

	def checkRunning
		# normaler http request mit standart HTTParty gem
  		response = HTTParty.get($serverurl , 
  		:headers => { 'Content-Type' => 'text/plain'})
		# checkt ob der response code dem erwarteten entspricht
  		response.code
  	end

  	#sends request to asnova to login as quest
  	#returns authentification cookie
  	def loginAsGuest
  		# HTTP request with modified HTTParty class
  		HTTPartyNoFollow.get($serverurl + "/auth/login?type=guest&role=SPEAKER",
  		:headers => { 'Referer' => 'http://localhost:8080/arsnova-war/' })
  		rescue HTTParty::RedirectionTooDeep => e 
  		e.response.code.should == "302"
		#return user session id
  		e.response.header['Set-Cookie']
  		
  	end

  	#retrieves Information of the current logged in user
  	#returns response from server
  	def getUserInformation(cookie)
  		response = HTTParty.get($serverurl + "/auth/",
  		:headers => { 'Content-Type' => 'text/plain', 'Cookie' => cookie})
  		response

  	end
end

module Session
	extend self

	#creates new session
	#returns sessionid and response from server
  	def createSession(cookie)
  		response = HTTParty.post($serverurl + "/session/",
    	:body => {:name => 'test',
              :shortName => 'test'}.to_json,
  		:headers => { 'Content-Type' => 'application/json', 'Cookie' => cookie})
  		sessionid = JSON.parse(response.body)["keyword"] 		
  		return sessionid, response
  	end

end