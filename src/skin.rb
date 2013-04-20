require 'yaml'
require 'config'

module SkinManager
	class Skin
		attr_reader :name, :files, :root_dir
		attr_accessor :active
		include Enumerable

		def initialize(name, files)
			@name = name
			@files = files
			@active = false
			@root_dir = File.join(AppCon::SKIN_DIR, name)
		end

		def [](index)
			@files[index]
		end

		def each(&block)
			@files.each(&block)
		end

		def active?
			@active
		end
	end
end

# STRIP FILE NAMES DOWN TO JUST tf/**/* FOR EASIER DIS/ACTIVATING