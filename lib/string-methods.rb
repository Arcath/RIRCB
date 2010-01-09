class String
	def privmsg?
		self=~/^\:.*!.*\@.*PRIVMSG\ .* \:.*/
	end
	def part?
		self=~/^\:.*!.*\@.*PART\ \#.*/
	end
	def quit?
		self=~/^\:.*!.*\@.*QUIT\ :.*/
	end
	def join?
		self=~/^\:.*!.*\@.*JOIN\ :\#.*/
	end
	def op?
		self=~/^\:.*!.* MODE \#.* \+o .*/
	end
	def deop?
		self=~/^\:.*!.* MODE \#.* \-o .*/
	end
	def invite?
		self=~/^\:.*!.* INVITE .* \:.*/
	end
	def ping?
		self=~/^PING :.*/
	end
end
