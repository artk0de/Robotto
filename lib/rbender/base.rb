require 'rbender/sessionmanager'
require 'rbender/keyboard_inline'
require 'rbender/mongo_client'
require 'rbender/state'
require 'rbender/config_handler'
require 'rbender/methods'
require 'rbender/keyboard'

require 'telegram/bot'

class RBender::Base
  attr_accessor :api
  include RBender::SessionManager

  public

  def initialize
    @states       = {}
    @global_state = nil
    @modules_block
  end

  def modules(&modules_block)
    @modules_block = modules_block
  end

  # Runs the bot with server
  def run!
    puts "Bot is loading...".green
    puts "Bot is running...".green
    Telegram::Bot::Client.run(@token) do |bot|
      @api = bot.api

      unless @modules_block.nil?
        instance_exec(@api, @mongo_client, &@modules_block)
      end
      bot.listen do |message| # When message has gotten
        begin
          process_message(message)
        rescue => ex
          puts ex.message.red
          puts ex.backtrace_locations
        end
      end
    end
  end


  # @param [Hash] params - hash with params
  #
  # Available parameters:
  # * mongo (required) connection string
  # * bot_name (required) name of bot
  # * token (required) token
  def set_params(params)
    RBender::MongoClient.setup(params['title'], params['mongo'])

    session_setup(RBender::MongoClient.client)

    @token                       = params['development']['token']
    RBender::ConfigHandler.token = @token

    # if params.has_key? localizations
    #
    # end
  end

  # Adds new state to the bot.
  # @param [String] state_name - name of the state
  # @param [Block] block - actions while state has invocked
  #
  def state(state_name, &block)
    if @states.has_key? state_name
      raise "State :#{state_name} is duplicated!"
    else
      @states[state_name] = block
    end
  end


  def global(&block)
    if @global_state
      raise 'Global state already defined: You\'ve trying to define too much :global blocks'
    else
      @global_state = block
    end
  end

  private

  def process_message(message)
    chat_id = message.from.id # Unique chat ID

    session = session(chat_id, message)


    state        = session[:state] # User's state
    state_block  = @states[state] # Block of the state
    state_object = RBender::State.new message, # Object to invoke
                                      @api,
                                      session,
                                      &state_block
    state_object.instance_eval(&@global_state) unless @global_state.nil?
    state_object.build
    state_object.invoke

    if is_start_message? message
      state_object.invoke_before if state_object.has_before?
    end

    save_session session

    state_new = session[:state] # New user's state

    on_state_changed(state_object,
                     state,
                     state_new,
                     message,
                     session)
  end

  def on_state_changed(state_object, state_old, state_new, message, session)
    if state_new != state_old # If state has changed
      state_object.invoke_after if state_object.has_after? #invoke after hook for an old state

      state_new_block = @states[state_new]
      state_object    = RBender::State.new message,
                                           @api,
                                           session,
                                           &state_new_block

      state_object.instance_eval(&@global_state) unless @global_state.nil?
      state_object.build

      if state_object.has_keyboard? # Invoke a keyboard if it's exists
        state_object.build_keyboard
        state_object.invoke_keyboard
      end

      state_object.invoke_before if state_object.has_before? #invoke before hook for a new state
      save_session session
    else
      if state_object.has_keyboard? # Invoke a keyboard if it's exists
        unless state_object.get_keyboard.one_time? or not state_object.get_keyboard.force_invoked?
          state_object.build_keyboard
          state_object.invoke_keyboard
        end
      end
    end
  end

  def session(chat_id, message)
    if has_session?(chat_id)
      session = load_session(chat_id)
    else # If user is new
      session = { state:                  :start,
                  state_stack:            [],
                  keyboard_switchers:     {},
                  keyboard_switch_groups: {},
                  lang:                   :default
      }
    end

    session[:user] = {
        chat_id:    chat_id,
        first_name: message.from.first_name,
        last_name:  message.from.last_name,
        user_name:  message.from.username
    }

    session[:user].freeze # User's data must be immutable!

    if is_start_message? message
      session[:state]       = :start
      session[:state_stack] = []
    end

    session
  end

  def is_start_message?(message)
    if message.instance_of? Telegram::Bot::Types::Message
      message.text == '/start' ? true : false
    else
      false
    end
  end
end


