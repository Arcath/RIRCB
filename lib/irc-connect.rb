class IRC
	require 'socket'
	def connect(server, nick, host, name, port, pass)
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
		if pass then
			puts "Identifiying to Services"
			send("PRIVMSG NickServ :IDENTIFY #{pass}")
			msg=self.receive
			puts "Identified as #{nick}"
		end
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
	def indentified?(nick)
		self.send("WHOIS #{nick}")
		whois=self.receive
		out=false
		begin
			Timeout::timeout(1) {
				while whois =~ /3[0-9][0-9] #{@nick}/ do
					begin
							out = (whois =~ /330/).integer? unless out
					rescue
				
					end
					puts "Still running the ident"
					whois=self.receive unless out
					whois="" if out
				end
			}
		rescue Timeout::Error
			out=false
		end
		return out
	end
	def names(chan)
		send("NAMES #{chan}")
	end
end
