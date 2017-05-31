class RBender::State

	def initialize(message, api, session, &state_block)
		@message          = message
		@api              = api
		@session          = session
		@state_block      = state_block
		@keyboard         = nil
		@inline_keyboards = {}
		@action_after     = nil
		@action_before    = nil
		@text_action      = nil
		@helpers_block    = nil
		@methods          = RBender::Methods.new(message, api, session)
	end

	def get_keyboard
		@keyboard
	end

	def message
		@message
	end

	# Invokes states and processes user's input
	def invoke
		case message
			when Telegram::Bot::Types::CallbackQuery
				process_callback
			when Telegram::Bot::Types::Message
				if @message.text
					process_text_message
				elsif @message.photo
					process_photo
				end

			when Telegram::Bot::Types::Document
				if @message.photo
					process_photo
				end
			else
				raise "This type isn't available: #{message.class}"
		end
	end

	def process_photo
		instance_exec(message.photo, &@photo_action) unless @photo_action.nil?
	end
	# Process if message is just text
	def process_text_message

		unless @keyboard.nil? # if state has keyboard
			@keyboard.instance_eval(&@helpers_block) unless @helpers_block.nil?
			build_keyboard

			@keyboard.markup_final.each do |btn, final_btn|
				if message.text == final_btn
					instance_exec(&@keyboard.actions[btn])
				end
			end
		end

		unless @text_action.nil?
			instance_exec(@message.text, &@text_action)
		end

	end

	# Process if message is inline keyboard callback
	def process_callback
		keyboard_name, action = @message.data.split(RBender::CALLBACK_SPLITTER)
		keyboard              = @inline_keyboards[keyboard_name.to_sym]
		keyboard.instance_eval(&@helpers_block) unless @helpers_block.nil?
		keyboard.invoke unless keyboard.nil?

		unless keyboard.nil?
			unless keyboard.buttons_actions[action].nil?
				instance_eval(&keyboard.buttons_actions[action])
			else
				raise "There is no action called '#{action}'"
			end
		else
			edit_message_text text: "deleted"
		end
	end

	def build
		instance_exec(&@state_block)
	end

	def build_keyboard
		@keyboard.build(@session)
	end

	def invoke_keyboard

		@api.send_message(chat_id:      message.from.id,
											text:         @keyboard.response,
											reply_markup: @keyboard.markup_tg)
	end

	def invoke_before
		instance_eval(&@action_before)
	end

	def has_after?
		@action_after.nil? ? false : true
	end

	def has_before?
		@action_before.nil? ? false : true
	end

	def invoke_after
		instance_eval(&@action_after)
	end

	def has_keyboard?
		@keyboard.nil? ? false : true
	end

	public

	# adds inline keyboard
	def keyboard_inline(inline_keyboard_name, &inline_keyboard_block)
		@inline_keyboards[inline_keyboard_name] = RBender::KeyboardInline.new(inline_keyboard_name,
																																					@session,
																																					inline_keyboard_block)
	end

	#before hook
	def before(&action)
		if @action_before.nil?
			@action_before = action
		else
			raise 'Too many before hooks!'
		end
	end

	#after hook
	def after(&action)
		if @action_after.nil?
			@action_after = action
		else
			raise 'Too many after hooks!'
		end
	end

	# Text callbacks
	def text(&action)
		if @text_action.nil?
			@text_action = action
		else
			raise 'Too many text processors!'
		end
	end

	def keyboard(response_message, &keyboard_block)
		@keyboard         = RBender::Keyboard.new response_message
		@keyboard.session = @session
		@keyboard.instance_eval(&keyboard_block)
	end

	#initialize helper methods
	def helpers(&helpers_block)
		@helpers_block = helpers_block
		instance_eval(&helpers_block)
	end

	def photo(&action)
		if @photo_action.nil?
			@photo_action = action
		else
			raise 'Too many image processors!'
		end
	end

	alias image photo
	alias picture photo


	def method_missing(m, *args, &block)
		if RBender::Methods.method_defined? m
			if block_given?
				if args.empty?
					return @methods.send(m, &block)
				else
					args = args[0] if args.count == 1
					return @methods.send(m, args, &block)
				end
			else
				if args.empty?
					return @methods.send(m)
				else
					args = args[0] if args.count == 1
					return @methods.send(m, args)
				end
			end
		else
			raise NoMethodError, "Method #{m} is missing"
		end
	end

end

