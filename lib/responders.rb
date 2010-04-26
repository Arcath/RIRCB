class Responder
	def initialize(irc,bot)
		@irc=irc
		@bot=bot
		begin
			@responses=YAML::load_file("config/responses.yml")
		rescue
			@responses={}
		end
	end
	
	def add(to,with)
		if @responses[to] then
			@responses[to].push(with)
		else
			@responses[to]=[with]
		end
		save
		true
	end
	
	def respond(msg,nick,chan)
		list="("
		@responses.keys.each do |response|
			list+=response
			list+="|" unless response == @responses.keys.last
		end
		list+=")"
		scanned=msg.gsub(/^#{@bot.nick}. /,"").downcase.scan(/^#{list}/)
		if !(scanned[0].nil?) && rand(2) == 1
			if @responses[scanned[0][0]].is_a? Array
				with=@responses[scanned[0][0]][rand(@responses[scanned[0][0]].count)].gsub("#nick",nick).gsub("#chan",chan)
				@irc.privmsg(with,chan)
			elsif @responses[scanned[0][0]].is_a? String
				with=@responses[@responses[scanned[0][0]]][rand(@responses[@responses[scanned[0][0]]].count)].gsub("#nick",nick).gsub("#chan",chan)
				@irc.privmsg(with,chan)			
			end
		end
	end
	
	def responses
		@responses
	end
	
	def alias_response(to,with)
		@responses[to]=with
		save
		true
	end
	
	private
	
	def save
		File.open("config/responses.yml", File::WRONLY|File::TRUNC|File::CREAT) do |out|
			YAML.dump(@responses, out)
		end
	end
end

class Command
	def respond(msg,chan,nick)
		if msg.split(", ").count == 2
			to=msg.split(", ")[0].downcase
			with=msg.split(", ")[1]
			@bot.responder.add(to,with)
			@irc.privmsg("Added!",chan)
		elsif msg.split(":").count == 2
			to=msg.split(":")[0].downcase
			with=msg.split(":")[1].downcase
			@bot.responder.alias_response(to,with)
			@irc.privmsg("Added Alias!",chan)
		else
			@irc.privmsg("#{nick}: Malformed Syntax",chan)
		end
	end
	
	def responses_for(msg,chan,nick)
		@irc.privmsg("Responses for #{msg}",chan)
		msg=msg.gsub("\r","").gsub("\n","")
		if @bot.responder.responses[msg]
			msg = @bot.responder.responses[msg] if @bot.responder.responses[msg].is_a? String
			string=""
			@bot.responder.responses[msg].each do |response|
				string+=response
				string+=", " unless response == @bot.responder.responses[msg].last
			end
			@irc.privmsg(string,chan)
		else
			@irc.privmsg("none",chan)
		end
	end
	
	def responds_to?(msg,chan,nick)
		@irc.privmsg("I respond to:",chan)
		string=""
		@bot.responder.responses.keys.each do |to|
			string+=to
			string+=", " unless to == @bot.responder.responses.keys.last
		end
	end	
end
