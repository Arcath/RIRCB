class Onevent
	def initialize(irc,bot,i18n)
		@bot=bot
		@irc=irc
		@i18n=i18n
		@events=[]
		Dir["onevent/*.rb"].each do |f|
			require f
			s=f.scan(/onevent\/(.*?)\.rb/).join
			@events.push(s) unless s == nil
		end
		@joins=[]
		@parts=[]
		@ops=[]
		@deops=[]
		@events.each do |event|
			responds = eval("self.#{event}_respond_to?")
			@joins.push(event) if responds.include? "join"
			@parts.push(event) if responds.include? "part"
			@ops.push(event) if responds.include? "op"
			@deops.push(event) if responds.include? "deop"
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
	def ops(nick,chan)
		@ops.each do |op|
			eval("self.#{op}('#{nick}','#{chan}')")
		end
	end
	def deops(nick,chan)
		@deops.each do |deop|
			eval("self.#{deop}('#{nick}','#{chan}')")
		end
	end
end
