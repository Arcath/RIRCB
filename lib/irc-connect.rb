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
		@nick=nick
	end
	def receive
		r=@con.recv(512)
		puts "Received: #{r}" unless r =~ /372 #{@nick}/
		r
	end
	def send(s)
		s=s.gsub(/\n/,'').gsub(/\r/,'')
		@con.send(s +"\n", 0)
		puts "Sent: #{s}"
	end
	def join(chan)
		self.send("JOIN #{chan}")
		puts "Joined #{chan}"
	end
	def privmsg(s,chan)
		self.send("PRIVMSG #{chan} :#{s}")
	end
	def notice(s,chan)
		self.send("NOTICE #{chan} :#{s}")
	end
	def part(s,chan)
		self.send("PART #{chan} :#{s}")
		puts "LEFT #{chan}"
	end
	def disconnect
		@con.close
	end
end
