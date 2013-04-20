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

			@skin_list.reject! { |s| !File.exists?(File.join(AppCon::SKIN_DIR, s))}
			_save_skin_list

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
			puts "Analyzing directory structure..."
			if Dir.exists? tf_dir
				sdir = File.join(AppCon::SKIN_DIR, name)

				if Dir.exists? sdir
					puts "Overwriting existing #{name} skin"
					_remove_skin_from_lists(name)
				else
					puts "Copying skin to #{sdir}"
					begin
						Dir.mkdir(sdir) unless Dir.exists? sdir
					rescue => e
						puts "Error creating backup skin directory: #{e.message}"
						puts "Could not add the skin."
						return
					end
				end
				FileUtils.cp_r(tf_dir, sdir)

				process_skin name, sdir
			else
				raise ArgumentError, "The skin couldn't be loaded due to file structure."
			end
		end

		def remove_skin(skin)
			if skin.is_a? String
				idx = @skins.index { |s| s.name == skin}
				raise ArgumentError, "#{skin} is not a known skin." if idx.nil?
				skin = @skins[idx]
			end

			if skin.active?
				deactivate_skin(skin)
			end

			FileUtils.remove_dir(skin.root_dir, :force => true)
			_remove_skin_from_lists(skin)
		end

		def process_skin(name, sdir)
			puts "Processing skin #{name} in #{sdir}"
			# Grab the skin files, but with tf/ as the root
			files = Dir.chdir(sdir) { Dir["tf/**/*"] }
			skin = SkinManager::Skin.new(name, files)
			@skins << skin
			@skin_list << name
			_save(skin)
			_save_skin_list
		end

		def save_skins
			puts "\nSaving skins..."
			@skins.each do |skin|
				_save(skin)
			end
			_save_skin_list
		end

		def save_skin (skin_name)
			idx = @skins.index { |s| s.name == skin_name}
			raise ArgumentError, "#{skin_name} is not a known skin." if idx.nil?
			_save(@skins[idx])
		end

		def activate_skin(skin_name)
			idx = @skins.index { |s| s.name == skin_name}
			raise ArgumentError, "#{skin_name} is not a known skin" if idx.nil?

			skin = @skins[idx]
			raise ArgumentError, "#{skin_name} is already active." if skin.active?

			if skin.any? { |f| File.file?(File.join(AppCon::TF_DIR, f))}
				puts "Activating this skin requires overwriting existing files."
			end

			FileUtils.cp_r(File.join(skin.root_dir, "tf"), AppCon::TF_DIR)

			skin.active = true
			_save(skin)
		end

		def deactivate_skin(skin_name)
			idx = @skins.index { |s| s.name == skin_name}
			raise ArgumentError, "#{skin_name} is not a known skin" if idx.nil?

			skin = @skins[idx]
			raise ArgumentError, "#{skin_name} is not active." if !skin.active?

			# Expand the skin's file names
			del_files = skin.map { |f| File.join(AppCon::TF_DIR, f) }

			FileUtils.remove(del_files, :force => true)

			skin.active = false
			_save(skin)
		end

		def list
			@skin_list
		end

		def active
			@skins.select { |s|
				s.name if s.active?
			}
		end

		private
		def _save(skin)
			sfile = File.join(skin.root_dir, "#{skin.name}.yml")
			puts "Save #{skin.name} to #{sfile}"
			File.open(sfile, "w") do |file|
				file.puts YAML::dump(skin)
			end
		end

		def _save_skin_list
			File.open(SKIN_LIST_FILE, "w") do |file|
				file.puts YAML::dump(@skin_list)
			end
		end

		def _remove_skin_from_lists(skin)
			if skin.is_a? String
				@skins.reject! { |s| s.name == skin}
				@skin_list.reject! { |n| n == skin}
			elsif skin.is_a? SkinManager::Skin
				@skins.reject! { |s| s.name == skin.name}
				@skin_list.reject! { |n| n == skin.name}
			end
			_save_skin_list
		end
	end
end