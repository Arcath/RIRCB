class Ontimer
	def initialize(irc,bot,i18n)
		@irc=irc
		@i18n=i18n
		@bot=bot
		@events=[]
		Dir["ontimer/*.rb"].each do |f|
			require f
			s=f.scan(/ontimer\/(.*?)\.rb/).join
			@events.push(s) unless s == nil
		end
	end
	def events
		@events
	end
	def run
		@bot.channel.each do |chan|
			@events.each do |event|
				eval "self.#{event}(\"#{chan}\")"
			end
		end
	end
end
