require "skin"
require "config"

require "yaml"
require "fileutils"
require "singleton"

module SkinManager
	class Manager
		include Singleton

		attr_accessor :skins, :skin_list

		SKIN_LIST_FILE = File.join(AppCon::DATA_DIR, "skinlist.yml")

		def initialize
			@skin_list = []
			if !File.exists? SKIN_LIST_FILE
				File.open(SKIN_LIST_FILE, "w") {}
			else
				@skin_list = YAML.load_file(SKIN_LIST_FILE) || []
			end

			@skins = @skin_list.map do |s|
				puts "Loading #{s}..."
				sdir = File.join(AppCon::SKIN_DIR, s, "#{s}.yml")
				skin = YAML.load_file(sdir)
				skin
			end
		end
		
		def add_skin(name, dir)
			puts "Adding skin..."
			raise ArgumentError, "#{dir} does not exist" unless Dir.exists? dir

			# First use case: Skin has root "tf" directory structure
			tf_dir = File.join(dir, "tf")
			puts "Looking for tf folder (#{tf_dir})"
			if Dir.exists? tf_dir
				sdir = File.join(AppCon::SKIN_DIR, name)
				puts "Copying skin to #{sdir}"
				Dir.mkdir(sdir)
				FileUtils.cp_r(tf_dir, sdir)

				process_skin name, sdir
			else
				raise ArgumentError, "The skin couldn't be loaded due to file structure."
			end
		end

		def process_skin(name, sdir)
			puts "Processing skin #{name} in #{sdir}"
			files = Dir["#{sdir}/tf/**/*"]
			@skins << SkinManager::Skin.new(name, files)
			@skin_list << name
		end

		def save_skins
			puts "Saving skins..."
			@skins.each do |skin|
				_save(skin)
			end
			File.open(SKIN_LIST_FILE, "w") do |file|
				file.puts YAML::dump(@skin_list)
			end
		end

		def save_skin (skin_name)
			idx = @skins.index { |s| s.name == skin_name}
			_save(@skins[idx])
		end

		def list
			@skin_list
		end

		def active
			@skins.collect { |s|
				s.active? ? s.name : false
			}
		end

		private
		def _save skin
			sfile = File.join(AppCon::SKIN_DIR, skin.name, "#{skin.name}.yml")
			puts "Save #{skin.name} to #{sfile}"
			File.open(sfile, "w") do |file|
				file.puts YAML::dump(skin)
			end
		end
	end
end