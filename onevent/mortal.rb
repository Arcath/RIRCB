class Onevent
	def mortal(s,chan)
		@irc.privmsg("#{s} is a mere mortal again!",chan)
	end
	def mortal_respond_to?
		return ["deop"]
	end
end
