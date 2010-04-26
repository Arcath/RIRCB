class Command
	def tictactoe(input,chan,nick)
		if @game then
			#Continue Game
			x=input.split(",")[0].to_i-1
			y=input.split(",")[1].to_i-1
			if !(x && y) then
				@irc.privmsg("#{nick}: You must enter a X,Y Co-ordinate",chan)
			elsif x >=4 || y >=4 then
				@irc.privmsg("#{nick}: You must enter a X,Y Co-ordinate less than or equal to 3",chan)
			elsif x <=0 || y <=0 then
				@irc.privmsg("#{nick}: You must enter a X,Y Co-ordinate greater than or equal to 1",chan)
			else
				if nick != @turn && @turn != nil then
					@irc.privmsg("Its not your turn!",chan)
				else
					if @game[x][y] != " " then
						@irc.privmsg("That space has already been taken",chan)
					else
						@game[x][y]=@next
						if @next == "X" then
							@next="O"
						else
							@next="X"
						end
						if @turn == nil then
							@turn = @p1
							@p2=nick
						elsif @turn == @p1 then
							@turn = @p2
						else
							@turn = @p1
						end
						tictactoe_grid(chan)
						tictactoe_won?(nick,chan)
					end
				end
			end
		else
			#Start a new one
			@game=[[" "," "," "],[" "," "," "],[" "," "," "]]
			@next="X"
			@p1=nick
			@p2=nil
			@turn=@p1
			@irc.privmsg("Starting a New Game of tic tac toe",chan)
			tictactoe_grid(chan)
		end
	end
	
	def tictactoe_grid(chan)
		@irc.privmsg("#{@game[0][0]}|#{@game[0][1]}|#{@game[0][2]}",chan)
		@irc.privmsg("#{@game[1][0]}|#{@game[1][1]}|#{@game[1][2]}",chan)
		@irc.privmsg("#{@game[2][0]}|#{@game[2][1]}|#{@game[2][2]}",chan)
	end
	def tictactoe_won?(nick,chan)
		takenspaces=0
		col=[true,true,true]
		vp=[nil,nil,nil]
		i=0
		@game.each do |g|
			p=nil
			row=true
			j=0
			g.each do |c|
				if c == " " then
					row=false
					col[j]=false
				else
					takenspaces+=1
				end
				if p == nil then
					p=c
				elsif c != p
					row=false
				end
				if vp[j] == nil then
					vp[j]=c
				elsif c != vp[j]
					col[j]=false
				end
				j+=1
			end
			if row == true
				@won=true
			end
			i+=1
		end
		if @won == false then
			@won=true if col.includes? true
		end
		if @won == true
			@irc.privmsg("#{nick} has won!",chan)
			@game=nil
			@p2=nil
			@turn=nil
		elsif takenspaces == 9
			@irc.privmsg("You all loose",chan)
		end
	end
end
