class Onevent
	def godlike(s,chan)
		@irc.privmsg("#{s} is Godlike!",chan)
	end
	def godlike_respond_to?
		return ["op"]
	end
end
