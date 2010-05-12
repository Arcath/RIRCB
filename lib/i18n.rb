class I18n
	def initialize(lang)
		@lang=lang
		begin
			@yaml=YAML::load_file("i18n/#{lang}.yml")
		rescue Errno::ENOENT
			@yaml=YAML::load_file("i18n/en.yml")
			puts "#{lang} is not avliable, falling back to english"
			sleep 4
		end
	end
	def phrase(group,phrase,args = [])
		output=@yaml[group][phrase]
		i=1
		args.each do |arg|
			output=output.gsub("$#{i}",arg)
			i+=1
		end
		output
	end
	def forcmd(command,phrase,args = [])
		begin
			output=YAML::load_file("i18n/commands/#{command}.#{@lang}.yml")[phrase]
		rescue Errno::ENOENT
			output=YAML::load_file("i18n/commands/#{command}.en.yml")[phrase]
		end
		i=1
		args.each do |arg|
			output=output.gsub("$#{i}",arg)
			i+=1
		end
		output
	end
	def forevent(event,phrase,args = [])
		begin
			output=YAML::load_file("i18n/onevent/#{event}.#{@lang}.yml")[phrase]
		rescue Errno::ENOENT
			output=YAML::load_file("i18n/onevent/#{event}.en.yml")[phrase]
		end
		i=1
		args.each do |arg|
			output=output.gsub("$#{i}",arg)
			i+=1
		end
		output
	end
	def fortimer(timer,phrase,args = [])
		begin
			output=YAML::load_file("i18n/ontimer/#{timer}.#{@lang}.yml")[phrase]
		rescue Errno::ENOENT
			output=YAML::load_file("i18n/ontimer/#{timer}.en.yml")[phrase]
		end
		i=1
		args.each do |arg|
			output=output.gsub("$#{i}",arg)
			i+=1
		end
		output
	end
end
