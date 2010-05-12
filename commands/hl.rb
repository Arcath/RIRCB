class Command
	def hl(msg,chan,nick)
		if @hlgame then
			int=msg.to_i
			@irc.privmsg(@i18n.forcmd("hl","higher",[int.to_s]),chan) if int <= @hlgame-1
			@irc.privmsg(@i18n.forcmd("hl","win",[nick,int.to_s]),chan) if int == @hlgame
			@irc.privmsg(@i18n.forcmd("hl","lower",[int.to_s]),chan) if int >= @hlgame+1
			@hlgame=nil if int == @hlgame
		else
			unless msg.length >= 8
				unless msg.to_i <= 10
					@hlgame=rand(msg.to_i)
					@irc.privmsg(@i18n.forcmd("hl","start",[msg]),chan)
				else
					@irc.privmsg(@i18n.forcmd("hl","mustbe10"),chan)
				end
			else
				@irc.privmsg(@i18n.forcmd("hl","below"),chan)
			end
		end
	end
end
