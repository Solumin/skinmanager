$: << File.dirname(__FILE__)
require "config"
require "exceptions"
require "manager"
# require "skin"
# module SkinManager
@@mann = ""
begin
@@mann = SkinManager::Manager.instance
rescue
	warn "Something's wrong in the manager"
	exit
end

def add(&blk)
	@name, @folder = "", ""
	dialog :width => 300, :height => 200 do
		stack :width => "100%", :margin => 15 do
			flow :width => "100%" do
				para "Skin Name:", :margin_right => 20
				@name_entry = edit_line
			end

			para "Skin Location:", :margin_top => 5, :margin_right => 20
			flow :width => "100%" do
				@dir_entry = edit_line :marin_left => 20
				button "..." do
					@folder = ask_open_folder
					@dir_entry.text = @folder
				end
			end

			flow :width => "100%", :margin_top => 10 do
				button "OK", :margin_right => 20 do
					@name = @name_entry.text
					@@mann.add_skin(@name, @folder)
					blk.call
					close
				end
				button "Cancel" do
					close
				end
			end
		end
	end
end

def remove(&blk)
	@name = ""
	if @@mann.list.empty?
		alert "There are no skins that can be activated."
		return 
	end

	dialog :width => 250, :height => 150 do
		stack :width => "100%", :margin => 15 do
			para "Skin Name: ", :margin_right => 20
			@name_box = list_box :items => @@mann.list

			flow :width => "100%" do
				button "Remove", :margin_right => 20 do
					@name = @name_box.text
					if @name.nil?
						alert "Please select a skin."
						return 
					end
					begin
						@@mann.remove_skin(@name)
					rescue => e
						alert e.message
					end
					blk.call
					close
				end
				button "Cancel" do
					close
				end
			end
		end
	end
end

def activate(&blk)
	@name = ""
	if @@mann.inactive.empty?
		alert "There are no skins that can be activated."
		return 
	end

	dialog :width => 250, :height => 150 do
		stack :width => "100%", :margin => 15 do
			para "Skin Name: ", :margin_right => 20
			@name_box = list_box :items => @@mann.inactive

			flow :width => "100%" do
				button "Activate", :margin_right => 20 do
					@name = @name_box.text
					if @name.nil?
						alert "Please select a skin."
						return 
					end
					begin
						@@mann.activate_skin(@name)
					rescue => e
						alert e.message
					end
					blk.call
					close
				end
				button "Cancel" do
					close
				end
			end
		end
	end
end

def deactivate(&blk)
	@name = ""
	if @@mann.active.empty?
		alert "There are no active skins."
		return
	end

	dialog :width => 250, :height => 150 do
		stack :width => "100%", :margin => 15 do
			para "Skin Name: ", :margin_right => 20
			@name_box = list_box :items => @@mann.active

			flow :width => "100%" do
				button "Deactivate", :margin_right => 20 do
					@name = @name_box.text
					if @name.nil?
						alert "Please select a skin."
						return 
					end
					begin
						@@mann.deactivate_skin(@name)
					rescue => e
						alert e.message
					end
					close
					blk.call
				end
				button "Cancel" do
					close
				end
			end
		end
	end
end

def format_skin_list
	 @@mann.skins.map { |s| [s.active? ? strong(s.name) : s.name, "\n"] }.flatten
end

begin
	SkinManager::AppCon.test
rescue SkinManager::Exceptions::ConfigError => e
	alert "Configuration error: #{e.message}"
rescue => e
	alert "Error initializing Skin Manager:\n#{e.message}"
	exit
else
	# alert "Configuration loaded successfully."
# 	puts "TF directory: #{AppCon::TF_DIR}"
# 	puts "Data storage: #{AppCon::DATA_DIR}"
# 	puts "Skin storage: #{AppCon::SKIN_DIR}"
end

Shoes.app :width => 400, :height => 200, :scroll => false do
	flow :width => "100%", :height => "100%", :scroll => false do
		@list_stack = stack :width => "60%", :height => "100%", :scroll => true, :margin_right => gutter do
			para "Installed Skins:"
			@list_para = para format_skin_list
		end

		stack :width => "40%", :margin => 5 do
			background lightblue, :width => "200%", :height => "200%", :top => -5, :left => -(10+gutter)
			button "Add Skin", :width => "80%", :margin => 10 do
				# alert ("This would start the add skin process")
				add{@list_para.text = format_skin_list}
			end.focus
			button "Remove Skin", :width => "80%", :margin => 10 do
				# alert ("This would start the remove process")
				remove{@list_para.text = format_skin_list}
			end
			button "Activate Skin", :width => "80%", :margin => 10 do
				# alert ("This would install a skin")
				activate {@list_para.text = format_skin_list}
			end
			button "Deactivate Skin", :width => "80%", :margin => 10 do
				# alert ("This would remove an installed skin")
				deactivate{@list_para.text = format_skin_list}
			end
		end
	end
end
# end