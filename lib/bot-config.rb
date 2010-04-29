class Bot
	require 'yaml'
	require 'timeout'
	def initialize(irc)
		@irc=irc
		@chanmans=[]
		@config=YAML::load_file("config/bot.yml")
		puts "Starting #{@config["nick"]} on #{@config["server"]}"
		puts "**********************************************************"
		puts "Connecting to IRC Server"
		@irc.connect(@config["server"], @config["nick"], @config["host"], @config["name"], @config["port"], @config['pass'])
		puts "Joining Channel"
		@config["channel"].each do |chan|
			@irc.join(chan)
			puts @config["chanman"]
			if @config["chanman"] == "yes" then
				@chanmans.push(ChanMan.new(chan,@irc,self))
			end
		end
		puts "**********************************************************"
		puts "Loading Commands"
		@commands=Command.new(@irc,self)
		puts "Loaded:"
		puts @commands.commands
		puts "**********************************************************"
		puts "Loading On-Timer Events"
		puts "**********************************************************"
		puts "Loading Events"
		@ontimer=Ontimer.new(@irc,self)
		puts "Loaded:"
		puts @ontimer.events
		puts "**********************************************************"
		puts "Loading On-Event Events"
		puts "**********************************************************"
		puts "Loading Events"
		@onevent=Onevent.new(@irc,self)
		puts "Loaded:"
		puts @onevent.events
		puts "**********************************************************"
		puts "Loading Responders"
		puts "**********************************************************"
		@responder=Responder.new(@irc,self)
		@dead=[1,2,3,4,5,6,7,8,9,10]
	end
	def run
		begin
			Timeout::timeout(10) {
				msg=@irc.receive
				if msg.ping?
					server=msg.scan(/^PING :(.*)/).join
					@irc.send("PONG #{server}")
				elsif msg.privmsg?
					nick=msg.split(/\!/)[0].sub(/^\:/,'')
					chan=msg.scan(/.* PRIVMSG (.*?) \:.*/).join
					m=msg.scan(/.* PRIVMSG #{chan} \:(.*)/).join.sub("\r\n",'')
					if chan == @config["nick"]
						chan=msg.scan(/^\:(.*)!.*@.*/).join
					end
					cmdlist="("
					@commands.commands.each do |cmd|
						cmdlist+=cmd
						if cmd != @commands.commands[@commands.commands.count-1] then
							cmdlist+="|"
						end
					end
					cmdlist+=")"
					a=m.scan(/^#{@config["command"]}#{cmdlist}(.*)/)
					unless a[0].nil?
						parse=a[0][1].gsub(/^ /,'').gsub("\r","").gsub("\n","")
						command=a[0][0]
						puts "Running #{command} with #{parse}"
						if @commands.canuse(command,nick)
							eval "@commands.#{command}(\"#{parse}\",\"#{chan}\",\"#{nick}\")"
						else
							puts "#{nick} is not allowed to run #{command}"
							if @commands.denytochan
								@irc.privmsg("Im sorry #{nick}, i cant allow you to do that",chan)
							end
						end
					else
						@responder.respond(msg.scan(/.* PRIVMSG #{chan} \:(.*)/).join.sub("\r\n",''),msg.split(/\!/)[0].sub(/^\:/,''),chan) if @config['responder']
					end
					@commands.updateseen(nick.downcase,chan,"said something")
				elsif msg.join?
					nick=msg.scan(/^\:(.*)!.*\@.*JOIN\ :\#.*/).join
					chan=msg.scan(/^\:.*!.*\@.*JOIN\ :\#(.*)/).join
					chan="##{chan}"
					@onevent.joins(nick,chan) unless nick == @config["nick"]
				elsif msg.part?
					nick=msg.scan(/^\:(.*)!.*\@.*PART\ :\#.*/).join
					chan=msg.scan(/^\:.*!.*\@.*PART\ :\#(.*)/).join
					chan="##{chan}"
					@onevent.parts(nick,chan) unless nick == @config["nick"]
				elsif msg.op?
					nick=msg.scan(/^\:.*!.* MODE \#.* \+o (.*)/)
					chan=msg.scan(/^\:.*!.* MODE \#(.*) \+o .*/)
					chan="##{chan}"
					@onevent.ops(nick,chan) unless nick == @config["nick"]
				elsif msg.deop?
					nick=msg.scan(/^\:.*!.* MODE \#.* \-o (.*)/)
					chan=msg.scan(/^\:.*!.* MODE \#(.*) \-o .*/)
					chan="##{chan}"
					@onevent.deops(nick,chan) unless nick == @config["nick"]
				else
					dead? msg
				end
			}
		rescue Timeout::Error
			puts "No Messages"
		end
	end
	def reboot=(val)
		@reboot=val
	end
	def reboot?
		@reboot
	end
	def kill=(val)
		@kill=val
	end
	def kill?
		@kill
	end
	def channel
		@config["channel"]
	end
	def disconnect
		@irc.disconnect
	end
	def reloadcommands
		puts "**********************************************************"
		puts "Re-Loading Commands"
		@commands=Command.new(@irc,self)
		puts "Loaded:"
		puts @commands.commands
	end
	def nick
		@config["nick"]
	end
	def ontimer
		@ontimer.run
	end
	def timerlength
		@config["timer"]
	end
	def responder
		@responder
	end
	def dead?(msg)
		@dead.slice!(0)
		@dead.push(msg)
		i=1
		die=true
		1.upto(9) do
			die = false unless @dead[i] == @dead[i-1]
		end
		self.reboot=true if die
	end
end
