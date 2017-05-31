require 'rbender'

state :start do
	before do
		send_message(text: "Hello, pidar!")
		switch(:state_main)
	end
end

state :state_main do
	response = "Press a button"
	keyboard response do
		button :btn_one, "One" do
			send_message(text: "You've pressed 1st button")
		end

		button :btn_two, "Two" do
			send_message(text: "You've pressed 2nd button")
		end

		button :btn_third, "Three" do
			send_message(text: "You've pressed 3rd button")
		end

		add_line :btn_one
		add_line :btn_two
		add_line :btn_third

		resize
	end

	text do |text|
		if text == 'xyu'
			send_message(text: "CAM Xyu")
		end
	end

	photo do |photos|
		puts photos
		file_id = photos[1]['file_id']
		file = get_file(file_id: file_id)
		puts file
	end
end
