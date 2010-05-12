class Command
	def names(msg,chan,nick)
		names=@irc.names(chan)
		@irc.privmsg(@i18n.forcmd("names","users"),chan)
		string=""
		names.each do |name|
			string+="\"#{name}\" "
		end
		@irc.privmsg(string,chan)
	end
end
