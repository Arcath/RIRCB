class Onevent
	def godlike(s,chan)
		@irc.privmsg(@i18n.forevent("godlike","godlike",[s]),chan)
	end
	def godlike_respond_to?
		return ["op"]
	end
end
