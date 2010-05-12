class Onevent
	def mortal(s,chan)
		@irc.privmsg(@i18n.forevent("mortal","mortal",[s]),chan)
	end
	def mortal_respond_to?
		return ["deop"]
	end
end
