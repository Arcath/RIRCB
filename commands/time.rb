class Command
	def time(msg,chan)
		@irc.privmsg(Time.now,chan)
	end
end
