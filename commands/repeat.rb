class Command
	def repeat(msg,chan)
		@irc.privmsg(msg,chan)
	end
end
