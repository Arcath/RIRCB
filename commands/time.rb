class Command
	def time(msg,chan,nick)
		@irc.privmsg(Time.now,chan)
	end
end
