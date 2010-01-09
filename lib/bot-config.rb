class Bot
	require 'yaml'
	def initialize(irc)
		@irc=irc
		@config=YAML::load_file("config/bot.yml")
		puts "Starting #{@config["nick"]} on #{@config["server"]}"
		puts "**********************************************************"
		puts "Connecting to IRC Server"
		@irc.connect(@config["server"], @config["nick"], @config["host"], @config["name"], @config["port"])
		puts "Joining Channel"
		@irc.join(@config["channel"])
	end
	def run
		msg=@irc.receive
		if msg.ping?
			server=msg.scan(/^PING :(.*)/).join
			@irc.send("PONG #{server}")
		end
	end
end
