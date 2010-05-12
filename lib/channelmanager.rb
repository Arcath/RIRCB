class ChanMan
	def initialize(chan,irc,bot)
		@irc=irc
		@bot=bot
		puts @i18n.phrase("system","bechanman",[chan])
		begin
			@config=YAML::load_file("config/chanman/#{chan}.yml")	
		rescue
			@config={chan => chan, alwaysop => "no", banlist => {}}
		end
		puts @config
		if @config["alwaysop"] == "yes" then
			self.op
		end
	end
	def op
		@irc.send("MODE #{@config["chan"]} +O #{@bot.nick}")
	end
end
