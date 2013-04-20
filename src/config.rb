require "exceptions.rb"

module SkinManager
	module AppCon
		TF_DIR = "E:/Programs/Steam/steamapps/solumin/team fortress 2"

		Dir.chdir("..") do
			AppCon::DATA_DIR = File.join(Dir.pwd, "data")
		end
		SKIN_DIR = File.join(DATA_DIR, "skins")

		module_function
		def AppCon.test
			raise Exceptions::ConfigError, "Team Fortress 2 directory (#{TF_DIR}) does not exist" unless (File.directory? TF_DIR)
			raise Exceptions::ConfigError, "Skin storage directory (#{SKIN_DIR}) does not exist" unless (File.directory? SKIN_DIR)
		end
	end
end