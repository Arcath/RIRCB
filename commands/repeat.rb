class Command
	def repeat(msg,chan,nick)
		@irc.privmsg(msg,chan)
	end
end
