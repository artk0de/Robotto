require_relative '../r_bender'

class RBender::State
  def initialize(message, api, session, &state_block)
    @message = message
    @api = api
    @session = session
    @state_block = state_block
    @keyboard = nil
    @inline_keyboards = {}
    @action_after = nil
    @action_before = nil
    @text_action = nil
    @helpers_block = nil
  end

  def _keyboard
    @keyboard
  end

  # Invokes states and processes user's input
  def _invoke
    case message
      when Telegram::Bot::Types::CallbackQuery
        _process_callback
      when Telegram::Bot::Types::Message
        _process_text_message
      else
        puts "This type isn't available: #{message.class}"
    end
  end

  # Process if message is just text
  def _process_text_message

    unless @keyboard.nil? # if state has keyboard
      @keyboard.instance_eval(&@helpers_block) unless @helpers_block.nil?
      _build_keyboard

      @keyboard.markup_final.each do |btn, final_btn|
        if message.text == final_btn
          instance_exec(&@keyboard.actions[btn])

          unless (group_id = @keyboard.button_switch_group(btn)).nil? # Switch group's logic
            group_size = @keyboard.switch_groups[group_id].size
            @session[:_keyboard_switch_groups][group_id] += 1
            @session[:_keyboard_switch_groups][group_id] %= group_size
          end
          if @keyboard.switchers.member? btn # Switcher's Logic
            switcher_size = @keyboard.switchers[btn].size
            @session[:_keyboard_switchers][btn] += 1
            @session[:_keyboard_switchers][btn] %= switcher_size
          end
          return
        end
      end
    end

    unless @text_action.nil?

      instance_exec(@message.text, &@text_action)
    end

  end

  # Process if message is inline keyboard callback
  def _process_callback
    keyboard_name, action = @message.data.split(RBender::CALLBACK_SPLITTER)
    keyboard = @inline_keyboards[keyboard_name.to_sym]
    keyboard.instance_eval(&@helpers_block) unless @helpers_block.nil?
    keyboard._invoke unless keyboard.nil?

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

  def _build
    instance_exec(&@state_block)
  end

  def _build_keyboard
    @keyboard._build(@session)
  end

  def _invoke_keyboard

    @api.send_message(chat_id: message.from.id,
                      text: @keyboard.response,
                      reply_markup: @keyboard.markup_tg)
  end

  def _invoke_before
    instance_eval(&@action_before)
  end

  def has_after?
    @action_after.nil? ? false : true
  end

  def has_before?
    @action_before.nil? ? false : true
  end

  def _invoke_after
    instance_eval(&@action_after)
  end

  def has_keyboard?
    @keyboard.nil? ? false : true
  end

  #--------------
  # User methods
  #--------------

  def keyboard(response_message, &keyboard_block)
    @keyboard = RBender::Keyboard.new response_message
    @keyboard.session = @session
    @keyboard.instance_eval(&keyboard_block)
  end

  #initialize helper methods
  def helpers(&helpers_block)
    @helpers_block = helpers_block
    instance_eval(&helpers_block)
  end

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

  # adds inline keyboard
  def keyboard_inline(inline_keyboard_name, &inline_keyboard_block)
    keyboard = @inline_keyboards[inline_keyboard_name] = RBender::KeyboardInline.new(inline_keyboard_name,
                                                                                     @session,
                                                                                     inline_keyboard_block)
  end

  def inline_markup(name)

    raise "Keyboard #{name} doesn't exists!" unless @inline_keyboards.member? name
    keyboard = @inline_keyboards[name]
    keyboard.instance_eval(&@helpers_block) unless @helpers_block.nil?
    keyboard._build
    keyboard.markup_tg
  end

  def switch(state_to)
    @session[:_state_stack].push(@session[:_state])
    @session[:_state] = state_to
  end

  def switch_prev
    @session[:_state] = @session[:_state_stack].pop
  end

  def switcher_state(id)
    session[:_keyboard_switchers][id]
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
                                 text: text,
                                 show_alert: show_alert
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
    @api.send_message chat_id: chat_id,
                      text: text,
                      disable_web_page_preview: disable_web_page_preview,
                      disable_notification: disable_notification,
                      reply_to_message_id: reply_to_message_id,
                      parse_mode: parse_mode,
                      reply_markup: reply_markup
  end


  def edit_message_text(inline_message_id: nil,
                        text:,
                        message_id: @message.message.message_id,
                        parse_mode: nil,
                        disable_web_page_preview: nil,
                        reply_markup: nil)
    begin
      @api.edit_message_text chat_id: @message.from.id,
                             message_id: message_id,
                             text: text,
                             inline_message_id: inline_message_id,
                             parse_mode: parse_mode,
                             disable_web_page_preview: disable_web_page_preview,
                             reply_markup: reply_markup
    rescue
    end
  end

  def edit_message_reply_markup(chat_id: @message.from.id,
                                message_id: @message.message.message_id,
                                inline_message_id: nil,
                                reply_markup: nil)
    begin
      @api.edit_message_reply_markup chat_id: chat_id,
                                     message_id: message_id,
                                     inline_message_id: inline_message_id,
                                     reply_markup: reply_markup
    rescue
    end


  end
end

