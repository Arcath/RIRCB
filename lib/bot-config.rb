class Bot
	require 'yaml'
	require 'timeout'
	def initialize(irc)
		@irc=irc
		@config=YAML::load_file("config/bot.yml")
		puts "Starting #{@config["nick"]} on #{@config["server"]}"
		puts "**********************************************************"
		puts "Connecting to IRC Server"
		@irc.connect(@config["server"], @config["nick"], @config["host"], @config["name"], @config["port"])
		puts "Joining Channel"
		@config["channel"].each do |chan|
			@irc.join(chan)
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
						parse=a[0][1].gsub(/^ /,'')
						command=a[0][0]
						puts "Running #{command} with #{parse}"
						if @commands.canuse(command,nick)
							eval "@commands.#{command}(\"#{parse}\",\"#{chan}\")"
						else
							puts "#{nick} is not allowed to run #{command}"
							if @commands.denytochan
								@irc.privmsg("Im sorry #{nick}, i cant allow you to do that",chan)
							end
						end
					end
					@commands.updateseen(nick.downcase,chan,"privmsg")
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
end
