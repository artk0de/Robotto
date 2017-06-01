class RBender::Methods

	def initialize(message, api, session)
		@message = message
		@api     = api
		@session = session
	end

	#--------------
	# User methods
	#--------------

	# Set message user gets while keyboard has invoked
	def set_response(new_response)
		@keyboard.set_response(new_response)
	end

	# Returns session hash
	def session
		@session
	end

	# Returns message object
	def message
		@message
	end

	# Returns Inline keyboard object by name
	def inline_markup(name)
		raise "Keyboard #{name} doesn't exists!" unless @inline_keyboards.member? name
		keyboard = @inline_keyboards[name]
		keyboard.instance_eval(&@helpers_block) unless @helpers_block.nil?
		keyboard.build
		keyboard.markup_tg
	end

	def switch(state_to)
		@session[:state_stack].push(@session[:state])
		@session[:state] = state_to
	end

	def switch_prev
		@session[:state] = @session[:state_stack].pop
	end


	#--------------
	# API METHODS
	#--------------
	# Hides inline keyboard
	# Must be called from any inline keyboard state
	def hide_inline
		edit_message_reply_markup
	end

	# Hides keyboard's markup.
	def hide_keyboard

	end

	#
	# @param text [String] string
	#
	def answer_callback_query(text: nil,
														show_alert: nil)
		begin
			@api.answer_callback_query callback_query_id: @message.id,
																 text:              text,
																 show_alert:        show_alert
		rescue
		end
	end

	def send_message(text:,
									 chat_id: @message.from.id,
									 parse_mode: nil,
									 disable_web_page_preview: nil,
									 disable_notification: nil,
									 reply_to_message_id: nil,
									 reply_markup: nil)

		if text.strip.empty?
			raise "A text can't be empty or consists of space symbols only"
		end
		@api.send_message chat_id:                  chat_id,
											text:                     text,
											disable_web_page_preview: disable_web_page_preview,
											disable_notification:     disable_notification,
											reply_to_message_id:      reply_to_message_id,
											parse_mode:               parse_mode,
											reply_markup:             reply_markup
	end

	def edit_message_text(inline_message_id: nil,
												text:,
												chat_id: @message.from.id,
												message_id: @message.message.message_id,
												parse_mode: nil,
												disable_web_page_preview: nil,
												reply_markup: nil)
		if text.strip.empty?
			raise "A text can't be empty or consists of space symbols only"
		end
		@api.edit_message_text chat_id:                  chat_id,
													 message_id:               message_id,
													 text:                     text,
													 inline_message_id:        inline_message_id,
													 parse_mode:               parse_mode,
													 disable_web_page_preview: disable_web_page_preview,
													 reply_markup:             reply_markup
	end

	def edit_message_caption(inline_message_id: nil,
													 caption: nil,
													 chat_id: @message.from.id,
													 message_id: @message.message.message_id,
													 reply_markup: nil)
		if text.strip.empty?
			raise "A text can't be empty or consists of space symbols only"
		end
		@api.edit_message_text chat_id:                  chat_id,
													 message_id:               message_id,
													 caption:                     caption,
													 inline_message_id:        inline_message_id,
													 reply_markup:             reply_markup
	end

	def edit_message_reply_markup(chat_id: @message.from.id,
																message_id: @message.message.message_id,
																inline_message_id: nil,
																reply_markup: nil)
		@api.edit_message_reply_markup chat_id:           chat_id,
																	 message_id:        message_id,
																	 inline_message_id: inline_message_id,
																	 reply_markup:      reply_markup
	end

	def delete_message(chat_id: @message.from.id,
										 message_id:)
		@api.delete_message(chat_id: chat_id,
												message_id: message_id)
	end


	def get_file(file_id:)
		@api.get_file file_id: file_id
	end

	def get_me()
		@api.get_me
	end

	def forward_message(chat_id:,
											from_chat_id: @message.from.id,
											disable_notification: false,
											message_id:)
		@api.forward_message(chat_id:              chat_id,
												 from_chat_id:         from_chat_id,
												 disable_notification: disable_notification,
												 message_id:           message_id)
	end

	def send_photo(chat_id: @message.from.id,
								 photo:,
								 caption: nil,
								 disable_notification: false,
								 reply_to_message_id: nil,
								 reply_markup: nil)
		@api.send_photo(chat_id:              chat_id,
										photo:                photo,
										caption:              caption,
										disable_notification: disable_notification,
										reply_to_message_id:  reply_to_message_id,
										reply_markup:         reply_markup)
	end

	def send_audio(chat_id: @message.from.to,
								 audio:,
								 caption: nil,
								 duration: nil,
								 performer: nil,
								 title: nil,
								 disable_notification: false,
								 reply_to_message_id: nil,
								 reply_markup: nil)

		@api.send_audio(chat_id:              chat_id,
										audio:                audio,
										caption:              caption,
										duration:             duration,
										performer:            performer,
										title:                title,
										disable_notification: disable_notification,
										reply_to_message_id:  reply_to_message_id,
										reply_markup:         reply_markup)
	end

	def send_document(chat_id: @message.from.id,
										document:,
										caption: nil,
										disable_notification: false,
										reply_to_message_id: nil,
										reply_markup: nil)
		@api.send_document(chat_id:              chat_id,
											 document:             document,
											 caption:              caption,
											 disable_notification: disable_notification,
											 reply_to_message_id:  reply_to_message_id,
											 reply_markup:         reply_markup)
	end

	def send_sticker(chat_id: @message.from.id,
									 sticker:,
									 caption: nil,
									 disable_notification: false,
									 reply_to_message_id: nil,
									 reply_markup: nil)
		@api.send_sticker(chat_id:              chat_id,
											sticker:              sticker,
											caption:              caption,
											disable_notification: disable_notification,
											reply_to_message_id:  reply_to_message_id,
											reply_markup:         reply_markup)
	end

	def send_video(chat_id: @message.from.id,
								 video:,
								 width: nil,
								 height: nil,
								 caption: nil,
								 duration: nil,
								 disable_notification: false,
								 reply_to_message_id: nil,
								 reply_markup: nil)
		@api.send_video(chat_id:              chat_id,
										video:                video,
										width:                width,
										height:               height,
										caption:              caption,
										duration:             duration,
										disable_notification: disable_notification,
										reply_to_message_id:  reply_to_message_id,
										reply_markup:         reply_markup)
	end

	def send_voice(chat_id: @message.from.to,
								 voice:,
								 caption: nil,
								 duration: nil,
								 disable_notification: false,
								 reply_to_message_id: nil,
								 reply_markup: nil)

		@api.send_voice(chat_id:              chat_id,
										voice:                voice,
										caption:              caption,
										duration:             duration,
										disable_notification: disable_notification,
										reply_to_message_id:  reply_to_message_id,
										reply_markup:         reply_markup)
	end

	def send_video_note(chat_id: @message.from.id,
											video_note:,
											length: nil,
											duration: nil,
											disable_notification: false,
											reply_to_message_id: nil,
											reply_markup: nil)
		@api.send_video_note(chat_id:              chat_id,
												 video_note:           video_note,
												 length:               length,
												 duration:             duration,
												 disable_notification: disable_notification,
												 reply_to_message_id:  reply_to_message_id,
												 reply_markup:         reply_markup)
	end

	def send_location(chat_id: @message.from.to,
										latitude:,
										longitude:,
										disable_notification: false,
										reply_to_message_id: nil,
										reply_markup: nil)

		@api.send_location(chat_id:              chat_id,
											 latitude:             latitude,
											 longitude:            longitude,
											 disable_notification: disable_notification,
											 reply_to_message_id:  reply_to_message_id,
											 reply_markup:         reply_markup)
	end

	def send_venue(chat_id: @message.from.to,
								 latitude:,
								 longitude:,
								 title:,
								 address:,
								 foursquare_id: nil,
								 disable_notification: false,
								 reply_to_message_id: nil,
								 reply_markup: nil)

		@api.send_venue(chat_id:              chat_id,
										latitude:             latitude,
										longitude:            longitude,
										title:                title,
										address:              address,
										foursquare_id:        foursquare_id,
										disable_notification: disable_notification,
										reply_to_message_id:  reply_to_message_id,
										reply_markup:         reply_markup)
	end

	def send_contact(chat_id: @message.from.to,
									 phone_number:,
									 first_name:,
									 last_name: nil,
									 disable_notification: false,
									 reply_to_message_id: nil,
									 reply_markup: nil)

		@api.send_contact(chat_id:              chat_id,
											phone_number:         phone_number,
											first_name:           first_name,
											last_name:            last_name,
											disable_notification: disable_notification,
											reply_to_message_id:  reply_to_message_id,
											reply_markup:         reply_markup)
	end

	def send_chat_action(chat_id: @message.from.id,
											 action:)
		@api.send_chat_action(chat_id: chat_id,
													action:  action)
	end

	def get_user_profile_photos(chat_id: @message.from.id,
															offset: nil,
															limit: nil)
		@api.get_user_profile_photos(chat_id: chat_id,
																 offset:  offset,
																 limit:   limit)
	end

	def kick_chat_member(chat_id:,
											 user_id:)
		@api.kick_chat_member(chat_id: chat_id,
													user_id: user_id)
	end

	def unban_chat_member(chat_id:,
												user_id:)
		@api.unban_chat_member(chat_id: chat_id,
													 user_id: user_id)
	end

	def leave_chat(chat_id:)
		@api.leave_chat(chat_id: chat_id)
	end

	def get_chat(chat_id:)
		@api.get_chat(chat_id: chat_id)
	end

	def get_chat_administrators(chat_id:)
		@api.get_chat_administrators(chat_id: chat_id)
	end

	def get_chat_members_count(chat_id:)
		@api.get_chat_members_count(chat_id: chat_id)
	end

	def get_chat_member(chat_id:, user_id:)
		@api.get_chat_member(chat_id: chat_id,
												 user_id: user_id)
	end

end

