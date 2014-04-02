#These steps will be executed before and after each szenario

Before do
	Connection.checkRunning.should == 200
	#resest cookie
	unless (defined?($cookie)).nil? # will now return true or false
 		$cookie = nil
	end
	#reset session
	unless (defined?(@sessionid)).nil? # will now return true or false
 		@sessionid = nil
	end
end

After do
	#delete session if sessoin id is set
	unless @sessionid.nil?
   		@response = HTTParty.delete($serverurl + "/session/" + @sessionid,
    		:headers => { 'Content-Type' => 'text/plain', 'Cookie' => $cookie})
   		@response.code.should == 200
	end
end