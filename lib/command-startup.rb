class Command
	def initialize(irc,bot,i18n)
		@i18n=i18n
		@irc=irc
		@bot=bot
		@db=DB.new(self)
		@commands=["reboot","kill","reload","help","add","about","remove","responds_to","respond","responses_for"]
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
	def help(msg,chan,nick)
		s=@i18n.phrase("system","helpmsg",[@bot.nick])
		@irc.privmsg(s,chan)
		s=""
		@commands.map { |cmd| s+=cmd + ", " if canuse(cmd,nick) }
		s=s.gsub(/, $/,'')
		@irc.privmsg(s,chan)
		
	end
	def reboot(msg,chan,nick)
		@bot.reboot=true
		@irc.part(@i18n.phrase("system","reboot"),chan)
	end
	def kill(msg,chan,nick)
		@bot.kill=true
		@irc.part(@i18n.phrase("system","kill"),chan)
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
					if @auth["identified"] then
						if @irc.indentified? user then
							return true
						else
							return false
						end
					else
						return true
					end
				else
					return false
				end
			end
		rescue NoMethodError
			return cmdper(command)
		end
	end
	def reload(msg,chan,nick)
		@irc.notice(@i18n.phrase("system","reload"),chan)
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
