# require_relative '../rbender'
# require_relative 'sessionmanager'

require 'rbender/sessionmanager'
require 'rbender/keyboard_inline'
require 'rbender/mongo_client'
require 'rbender/state'

require 'telegram/bot'


class RBender::Base
  attr_accessor :api
  include RBender::SessionManager

  def initialize
    @states = {}
    @global_state = nil
    @modules_block
  end

  def modules(&modules_block)
    @modules_block = modules_block
  end

  # Runs the bot with server
  public
  def run!
    puts "Bot is loading...".green
    puts "Bot is running...".green
    Telegram::Bot::Client.run(@token) do |bot|
      @api = bot.api

      unless @modules_block.nil?
        instance_exec(@api, @mongo_client, &@modules_block)
      end
      bot.listen do |message| # When message has gotten
        # begin
          _process_message(message)
        # rescue => ex
        #   puts ex.message
        # end
      end
    end
  end

  public
  def _process_message(message)
    chat_id = message.from.id # Unique chat ID

    if has_session?(chat_id)
      session = load_session(chat_id)

    else # If user is new
      session = {_state: :start,
                 _state_stack: [],
                 _keyboard_switchers: {},
                 _keyboard_switch_groups: {},
                 _lang: :default
      }

    end
    session[:user] = {chat_id: chat_id,
                      first_name: message.from.first_name,
                      last_name: message.from.last_name,
                      username: message.from.username
    }

    session[:user].freeze # User's data must be immutable!

    if is_start_message? message
      session[:_state] = :start
      session[:_state_stack] = []
    end

    state = session[:_state] # User's state
    state_block = @states[state] # Block of the state
    state_object = RBender::State.new message, # Object to invoke
                                      @api,
                                      session,
                                      &state_block
    state_object.instance_eval(&@global_state) unless @global_state.nil?
    state_object._build
    state_object._invoke
    save_session session

    state_new = session[:_state] # New user's state

    unless state_new == state # If state has changed
      state_object._invoke_after if state_object.has_after? #invoke after hook for an old state

      state_new_block = @states[state_new]
      state_object = RBender::State.new message,
                                        @api,
                                        session,
                                        &state_new_block

      state_object.instance_eval(&@global_state) unless @global_state.nil?
      state_object._build

      if state_object.has_keyboard? # Invoke a keyboard if it's exists
        state_object._build_keyboard
        state_object._invoke_keyboard
      end

      state_object._invoke_before if state_object.has_before? #invoke before hook for a new state
    else
      if state_object.has_keyboard? # Invoke a keyboard if it's exists
        unless state_object._keyboard.one_time? or not state_object._keyboard.force_invoked?
          state_object._build_keyboard
          state_object._invoke_keyboard
        end
      end
    end
  end

  def is_start_message?(message)
    if message.instance_of? Telegram::Bot::Types::Message
      if message.text == '/start'
        true
      else
        false
      end
    end
  end

  # @param [Hash] params - hash with params
  #
  # Available parameters:
  # * mongo_server_ip (required)
  # * mongo server_port  (required)
  # * bot_name (required)
  # * token (required)
  # * localizations(optional) default = :default
  def set_params(params)
    RBender::MongoClient.setup(params[:bot_name],
                               params[:mongo_server_ip],
                               params[:mongo_server_port])

    session_setup(RBender::MongoClient.client)

    @token = params[:token]
    # if params.has_key? localizations
    #
    # end
  end


  # Adds new state to the bot.
  # @param [String] state_name - name of the state
  # @param [Block] block - actions while state has invoked
  #
  public
  def state(state_name, &block)
    unless @states.has_key? state_name
      @states[state_name] = block
    else
      raise "State name is duplicated!"
    end
  end


  def global(&block)
    @global_state = block
  end

end


