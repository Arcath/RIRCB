class Onevent
	def initialize(irc,bot)
		@bot=bot
		@irc=irc
		@events=[]
		Dir["onevent/*.rb"].each do |f|
			require f
			s=f.scan(/onevent\/(.*?)\.rb/).join
			@events.push(s) unless s == nil
		end
		@joins=[]
		@parts=[]
		@events.each do |event|
			responds = eval("self.#{event}_respond_to?")
			@joins.push(event) if responds.include? "join"
			@parts.push(event) if responds.include? "part"
		end
	end
	def events
		@events
	end
	def joins(nick,chan)
		@joins.each do |join|
			eval("self.#{join}('#{nick}','#{chan}')")
		end
	end
	def parts(nick,chan)
		@parts.each do |part|
			eval("self.#{part}('#{nick}','#{chan}')")
		end
	end
end
