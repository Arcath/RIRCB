require 'yaml'

task :setup do |t|
	puts "**********************************************************"
	puts "Starting RIRCB Setup"
	puts "**********************************************************"
	#Initial Setup Task
	puts "Running some system commands, dont worry its only a chmod and a mkdir"
	system("chmod +x script/run")
	system("mkdir -p datastore/")
	system("chmod 777 datastore")
	system("mkdir -p config/chanman/")
	system("chmod 777 config/chanman/")
	puts "**********************************************************"
	puts "Config"
	puts "**********************************************************"
	yaml={}
	puts "Nickname:"
	yaml["nick"]=STDIN.gets.chomp
	puts "Registration Password required if you have registered the bots nickname Reccomended if you intend to use channel manager:"
	yaml["pass"]=STDIN.gets.chomp
	puts "Real Name: (appears when being WHOISed)"
	yaml["name"]=STDIN.gets.chomp
	puts "Hostname: (can be anything host like)"
	yaml["host"]=STDIN.gets.chomp
	puts "Server:"
	yaml["server"]=STDIN.gets.chomp
	puts "Port:"
	yaml["port"]=STDIN.gets.chomp
	puts "Add Channels: leave it blank to end"
	chan=[]
	go=1
	c=1
	while go == 1
		puts "Channel ##{c}:"
		got=STDIN.gets.chomp
		if got != "" then
			chan.push(got)
		else
			go=0
		end
		c+=1
	end
	yaml["channel"]=chan
	puts "Command Chracter:"
	yaml["command"]=STDIN.gets.chomp
	puts "What language do you want to use (en=english):"
	yaml["lang"]=STDIN.gets.chomp
	puts "How long should pass between running timed events?"
	yaml["timer"]=STDIN.gets.chomp
	puts "Should I Manage your channel (enable chanman) (yes/no)"
	yaml["chanman"]=STDIN.gets.chomp
	puts "Should I Respond to tiggers with pre written responses (that you configure in channel) (yes/no)"
	yaml["responder"]=STDIN.gets.chomp
	puts "**********************************************************"
	puts "Dumping to YAML"
	puts "**********************************************************"
	File.open("config/bot.yml", File::WRONLY|File::TRUNC|File::CREAT) do |out|
		YAML.dump(yaml, out)
	end
end
