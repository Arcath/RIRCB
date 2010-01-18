class Command
	def console(msg,chan)
		a=eval(msg).inspect
		@irc.privmsg("#> #{a}",chan)
	end
end
