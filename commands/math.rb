class Command
	include Math
	require 'timeout'
	def math(math,chan,nick)
		#Some constants
		everything = 42
		leet = 1337
		#Perform the Math
		begin
			if math =~ /sleep/ or math =~ /eval/ or math =~ /Thread/ or math =~ /Timeout/ or math =~ /@/
				out = "Invalid Command"
			else
				Timeout::timeout(1) {
					out = Thread.new { $SAFE=4; eval math.gsub("^","**") }.value.inspect
				}
			end
			if out.length > 400
				if out.class == Integer
					out = out.standardForm(10)
				else
					out = out[0..400].to_s + '...'
				end
			end
		rescue SyntaxError
			out = "Syntax Error"
		rescue SecurityError
			out = "Insecure Operation"
		rescue ZeroDivisionError
			out = "Division By 0"
		rescue Timeout::Error
			out = "Timeout"
		rescue => error
			out = "Error #{error}"
		end
		@irc.privmsg("> #{out}",chan)
	end
end
