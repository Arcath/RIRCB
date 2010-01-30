class Ontimer
	def rsscheck(chan)
		@lastcheck ||= Time.now
		if @lastcheck <= Time.now - 600 then
			#RSS Checking Here
		end
	end
end
