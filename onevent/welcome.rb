class Onevent
	def welcome(s,chan)
		@irc.privmsg("Welcome to #{chan} #{s}!",chan)
	end
	def welcome_respond_to?
		return ["join"]
	end
end
