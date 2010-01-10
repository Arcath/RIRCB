class Command
	def initialize(irc,bot)
		@irc=irc
		@bot=bot
		@commands=["reboot","kill","reload"]
		Dir["commands/*.rb"].each do |f|
			require f
			s=f.scan(/commands\/(.*?)\.rb/).join
			@commands.push(s) unless s == nil
		end
		@auth=YAML::load_file("config/authentication.yml")
	end
	def commands
		@commands
	end
	def reboot(msg,chan)
		@bot.reboot=true
		@irc.part("Leaving, back soon",chan)
	end
	def kill(msg,chan)
		@bot.kill=true
		@irc.part("Leaving",chan)
	end
	def canuse(command,user)
		begin
			if cmdper(command) then
				#Needs inverting to false?
				if @auth["userinvertlist"][command].include? user then
					return false
				else
					return true
				end
			else
				#Needs inverting to true?
				if @auth["userinvertlist"][command].include? user then
					return true
				else
					return false
				end
			end
		rescue NoMethodError
			return cmdper(command)
		end
	end
	def reload(msg,chan)
		@irc.notice("Reloading Commands",chan)
		@bot.reloadcommands
	end
	def denytochan
		@auth["denytochan"]
	end
	
	private
	
	def cmdper(command)
		if @auth["commanddefault"] == "allow" && @auth["overidepermission"][command] != "deny" then
			return true
		elsif @auth["commanddefault"] == "deny" && @auth["overidepermission"][command] != "allow" then
			return false
		elsif @auth["overidepermission"][command] == "deny" then
			return false
		elsif @auth["overidepermission"][command] == "allow" then
			return true
		end
	end
end
