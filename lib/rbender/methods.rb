class RBender::Methods

	def initialize(message, api, session)
		@message = message
		@api = api
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

	def switcher_state(id)
		session[:keyboard_switchers][id]
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
												message_id: @message.message.message_id,
												parse_mode: nil,
												disable_web_page_preview: nil,
												reply_markup: nil)
		begin
			@api.edit_message_text chat_id:                  @message.from.id,
														 message_id:               message_id,
														 text:                     text,
														 inline_message_id:        inline_message_id,
														 parse_mode:               parse_mode,
														 disable_web_page_preview: disable_web_page_preview,
														 reply_markup:             reply_markup
		rescue
		end
	end

	def edit_message_reply_markup(chat_id: @message.from.id,
																message_id: @message.message.message_id,
																inline_message_id: nil,
																reply_markup: nil)
		begin
			@api.edit_message_reply_markup chat_id:           chat_id,
																		 message_id:        message_id,
																		 inline_message_id: inline_message_id,
																		 reply_markup:      reply_markup
		rescue
		end
	end

	def get_file(file_id:)
		@api.get_file file_id: file_id
	end
end

