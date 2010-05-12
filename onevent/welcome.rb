class Onevent
	def welcome(s,chan)
		@irc.privmsg(@i18n.forevent("welcome","welcome",[chan,s]),chan)
	end
	def welcome_respond_to?
		return ["join"]
	end
end
