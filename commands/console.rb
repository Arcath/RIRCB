class Command
	def console(msg,chan,nick)
		a=eval(msg).inspect
		@irc.privmsg("#> #{a}",chan)
	end
end
