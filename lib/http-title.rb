class HTTPTitle
	require 'open-uri'
	def initialize(bot,irc,i18n)
		@bot=bot
		@irc=irc
		@i18n=i18n
	end
	
	def parse(url,chan)
		title="naughty link"
		head=false
		header=""
		begin
			open(url) do |f|
				f.each_line do |line|
					if line =~ /<head>/ then
						head=true
					end
					header+=line if head
					if line =~ /<\/head>/ then
						head=false
					end
				end
			end
			title=header.scan(/<title>(.*?)<\/title>/m).join
			title = youtube title if title =~ /YouTube/
		rescue SocketError
			title="Dead Website"
		end
		@irc.privmsg(title,chan)
	end
	
	private
	
	def youtube(title)
		title.gsub(/^.*?Youtube.*?- (.*?)$/,"Video: \1")
	end
end
