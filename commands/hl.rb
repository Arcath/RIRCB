class Command
	def hl(msg,chan,nick)
		if @hlgame then
			int=msg.to_i
			@irc.privmsg("Higher than #{int}",chan) if int <= @hlgame-1
			@irc.privmsg("#{nick} wins with #{int}",chan) if int == @hlgame
			@irc.privmsg("Lower than #{int}",chan) if int >= @hlgame+1
			@hlgame=nil if int == @hlgame
		else
			unless msg.length >= 8
				@hlgame=rand(msg.to_i)
				@irc.privmsg("Game of Higher/Lower with #{msg}",chan)
			else
				@irc.privmsg("The highest number allowed is 9,999,999",chan)
			end
		end
	end
end
