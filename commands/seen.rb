class Command
	def seen(msg,chan,nick)
		ds=Datastore.new
		yaml=ds.load("seen")
		begin
			nick=msg.downcase
			hash=yaml[chan][nick]
			if hash then
				@irc.privmsg("#{msg} last #{hash["action"]} at #{hash["time"]}",chan)
			else
				@irc.privmsg("\"#{msg}\" has never posted on this channel",chan) 
			end
		rescue
			@irc.privmsg("\"#{msg}\" has never posted on this channel, and i had a whoopsie working this out",chan)
		end	
	end
	def updateseen(nick,chan,action)
		ds=Datastore.new
		yaml=ds.load("seen")
		begin
			yaml[chan][nick]={}
			yaml[chan][nick]["action"]=action
			yaml[chan][nick]["time"]=Time.now
		rescue NoMethodError
			yaml={chan => {nick => {"action" => action, "time" => Time.now}}}
			puts "Re-intialized seen datastore"
		end
		ds.save(yaml,"seen")
	end
end
