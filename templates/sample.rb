require 'rbender'
Dir["/lib/*.rb"].each {|file| require_relative file}

state :start do
	before do
		# - - - - - -
		# Before hook
		# - - - - - -
	end


	keyboard do
		set_response("Sample response") #response are required
		button :btn_1, "Btn1" do
			# do something
		end

		button :btn_2, "Btn2" do
			# do something
		end

		line :btn_1, :btn_2
		# - - - - - - -
		# Init keyboard
		# - - - - - - -
	end


	keyboard_inline :kb_inline do
		# - - - - - -
		# Init inline keyboard
		# - - - - - -
	end

	after do
		# - - - - - -
		# After hook
		# - - - - - -
	end

	text do |text|
		# - - - - - - - - - - - -
		# Process user's message
		# - - - - - - - - - - - -
	end
end

global do
	command '/command' do
		# command without params
	end

	command '/command2' do |params|
		# command with params
	end

	helpers do
		# - - - - - - - - - - -
		# Define global helpers
		# - - - -  - - - - - - -
	end
end