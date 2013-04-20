# Add current file to loadpath
$: << File.dirname(__FILE__)
require "config"
require "exceptions"
require "manager"
require "skin"

require "ap"

module SkinManager
	begin
		AppCon.test
	rescue Exceptions::ConfigError => e
		puts "Configuration error: #{e.message}"
	rescue => e
		puts "Error initializing Skin Manager:\n#{e.message}"
	# else
	# 	puts "Configuration loaded successfully."
	# 	puts "TF directory: #{AppCon::TF_DIR}"
	# 	puts "Data storage: #{AppCon::DATA_DIR}"
	# 	puts "Skin storage: #{AppCon::SKIN_DIR}"
	end

	mann = Manager.instance
	# begin
	# 	mann.add_skin("Eternal-Youth-Maiden", "E:\\My Documents\\GitHub\\skinmanager\\test\\skins\\Eternal-Youth-Maiden")
	# rescue => e
	# 	puts "Couldn't load skin :("
	# 	puts e.message
	# else
	# 	puts "Loaded skin!"
	# 	ap mann.list
	# end
	puts "\nActive skins:"
	ap mann.active
	mann.save_skins
end
