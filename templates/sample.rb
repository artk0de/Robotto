require 'rbender'

state :start do
	before do
		# - - - - - -
		# Before hook
		# - - - - - -
	end

	keyboard do
		# - - - - - - -
		# Init keyboard
		# - - - - - - -
	end

	inline_keyboard :kb_inline do
		# - - - - - -
		# Init inline keyboard
		# - - - - - -
	end

	after do
		# - - - - - -
		# After hook
		# - - - - - -
	end

	text do |message|
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