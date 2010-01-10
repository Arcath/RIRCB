class Command
	def seen(msg,chan)
		ds=Datastore.new
		yaml=ds.load("seen")
		if yaml[msg]
			@irc.privmsg("#{msg} last #{yaml[msg]["action"]} at #{yaml[msg]["time"]}")
		else
			@irc.privmsg("#{msg} has never posted on this channel",chan) 
		end	
	end
	def updateseen(nick,chan,action)
		ds=Datastore.new
		yaml=ds.load("seen")
		begin
			yaml[nick]["action"]=action
			yaml[nick]["time"]=Time.now
		rescue NoMethodError
			yaml={nick => {"action" => action, "time" => Time.now}}
			puts "Re-intialized seen datastore"
		end
		ds.save(yaml,"seen")
	end
end
