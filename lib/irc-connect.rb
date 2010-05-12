class IRC
	require 'socket'
	def connect(server, nick, host, name, port, pass)
		puts @i18n.phrase("irc","connecting",[server,port])
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
		puts @i18n.phrase("irc","connected",[nick])
		@nick=nick
		if pass then
			puts @i18n.phrase("irc","identifying")
			send("PRIVMSG NickServ :IDENTIFY #{pass}")
			msg=self.receive
			puts @i18n.phrase("irc","identified",[nick])
		end
	end
	def receive
		r=@con.recv(512)
		puts @i18n.phrase("irc","received",[r]) unless r =~ /372 #{@nick}/
		r
	end
	def send(s)
		s=s.gsub(/\n/,'').gsub(/\r/,'')
		@con.send(s +"\n", 0)
		puts @i18n.phrase("irc","sent",[s])
	end
	def join(chan)
		self.send("JOIN #{chan}")
		puts @i18n.phrase("irc","joined",[chan])
	end
	def privmsg(s,chan)
		self.send("PRIVMSG #{chan} :#{s}")
	end
	def notice(s,chan)
		self.send("NOTICE #{chan} :#{s}")
	end
	def part(s,chan)
		self.send("PART #{chan} :#{s}")
		puts @i18n.phrase("irc","left",[chan])
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
		names=[]
		recv=self.receive
		while !(recv =~ /366 #{@nick} #{chan}/) do
			list=recv.gsub(/.*#{chan} :#{@nick} /,"")
			listarray=list.split(" ")
			listarray.each do |entry|
				names.push(entry)
			end
			recv=self.receive
		end
		names
	end
	def i18n(i18n)
		@i18n=i18n
	end
end
