class Datastore
	def initialize
		@datadir="datastore/"
	end
	def load(key)
		begin
			out=YAML::load_file(@datadir + key + ".yml")	
		rescue
			out={}
		end
		return out
	end
	def save(a,key)
		File.open(@datadir + key + ".yml", File::WRONLY|File::TRUNC|File::CREAT) do |out|
			YAML.dump(a, out)
		end
	end
end
