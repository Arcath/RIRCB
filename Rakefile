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
	puts "**********************************************************"
	puts "Config"
	puts "**********************************************************"
	yaml={}
	puts "Nickname:"
	yaml["nick"]=STDIN.gets.chomp
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
	puts "How long should pass between running timed events?"
	yaml["timer"]=STDIN.gets.chomp
	puts "**********************************************************"
	puts "Dumping to YAML"
	puts "**********************************************************"
	File.open("config/bot.yml", File::WRONLY|File::TRUNC|File::CREAT) do |out|
		YAML.dump(yaml, out)
	end
end
