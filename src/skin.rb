require 'yaml'
require 'config'

module SkinManager
	class Skin
		attr_accessor :name, :files, :active
		include Enumerable

		def initialize(name, files)
			@name = name
			@files = files
			@active = false
		end

		def [](index)
			@files[index]
		end

		def each
			@files.each
		end

		def active?
			@active
		end
	end
end