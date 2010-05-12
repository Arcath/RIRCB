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
				out = @i18n.forcmd("math","invalid")
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
			out = @i18n.forcmd("math","syntax")
		rescue SecurityError
			out = @i18n.forcmd("math","insecure")
		rescue ZeroDivisionError
			out = @i18n.forcmd("math","div0")
		rescue Timeout::Error
			out = @i18n.forcmd("math","timeout")
		rescue => error
			out = @i18n.forcmd("math","error",[error])
		end
		@irc.privmsg("> #{out}",chan)
	end
end
