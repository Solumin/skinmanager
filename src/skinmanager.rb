# Add current file to loadpath
$: << File.dirname(__FILE__)
require "config"
require "exceptions"
require "manager"
require "skin"

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
	# mann.add_skin("Ambi-DR", "E:\\My Documents\\GitHub\\skinmanager\\test\\skins\\Ambassador_styled_dead_ringer")
	# mann.remove_skin("Ambi-DR")
	
	# rescue => e
	# 	puts "Couldn't load skin :("
	# 	puts e.message
	# else
	# 	puts "Loaded skin!"
	# 	ap mann.list
	# end
	# puts "\nActive skins:"
	# ap mann.active

	# puts "\n\nActivating skin:"
	# mann.activate_skin("Eternal-Youth-Maiden")
	# puts "Deactivating skin"
	# mann.deactivate_skin("EYM")

	# mann.save_skins
end
