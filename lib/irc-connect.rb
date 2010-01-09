class IRC
	require 'socket'
	def connect(server, nick, host, name, port)
		puts "Connecting to #{server} on port #{port}"
		@con=TCPSocket.new(server,port)
		send("USER " + nick + " " + host + " bla :" + name)
		send("NICK " + nick)
		msg=@con.recv(512)
		while msg !~ /^:.* 001.*/
			puts msg
			if msg =~ /Nickname is already in use/
				nick=nick+"_"
				send("NICK " + nick)
			end
			msg=@con.recv(512)
		end
		puts "Connected as #{nick}"
	end
	def receive
		r=@con.recv(512)
		puts "Received: #{r}"
		r
	end
	def send(s)
		s=s.gsub(/\n/,'').gsub(/\r/,'')
		@con.send(s +"\n", 0)
	end
	def join(chan)
		self.send("JOIN #{chan}")
		puts "Joined #{chan}"
	end
end
