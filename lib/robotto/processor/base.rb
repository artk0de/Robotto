# frozen_string_literal: true

module Robotto
  module Processor
    class Base
      include Robotto::Support::SessionManager

      CMD_START = '/start'.freeze

      attr_reader :api

      def initialize
        @states = {}
        @global_state = nil
      end

      # Sets configuration for bor on launch.
      #
      # @param [Hash] params - hash with params
      #
      # ----------------------------------------
      # Available parameters:
      # * mongo (required) connection string
      # * bot_name (required) name of bot
      # * token (required) token
      #
      def configure!
        config = Support::Config.instance

        Robotto::Mongo.setup config['title'], config['mongo']
        session_setup Robotto::Mongo.client
        @token = config.get('token')
        Robotto::Config.token = @token
      end

      def get(key)
        config[Support::Config.env][key]
      end

      # Adds new state to the bot.
      # @param [String] state_name - name of the state
      # @param [Block] block - actions while state has invoked.
      # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
      def state(state_name, &block)
        raise "State :#{state_name} is duplicated!" if @states.include?(state_name)

        @states[state_name] = block
      end

      alias screen state

      def global(&block)
        raise 'Global state already defined: You\'ve trying to define too much :global blocks' if @global_state

        @global_state = block
      end

      attr_accessor :message, :chat_id

      def process_message(message)
        self.message = message
        self.chat_id = message.from&.id || message.chat&.id # Unique chat ID

        state_klass = session[:state].capitalize.constantinize # User's state
        state_block = @states[state] # Block of the state
        state_object = state_klass.new(message, @api, session, &state_block) # Object to invoke

        state_object.instance_eval(&@global_state) if @global
        state_object.build
        state_object.invoke
        state_object.invoke_before if start_message? && state_object.before?

        save_session session

        state_new = session[:state] # New user's state

        on_state_changed! state_object, state, state_new, message, session
      end

      def on_state_changed!(state_obj, state_old, state_new, message, session)
        if state_new != state_old # If state has changed
          state_obj.invoke_after if state_obj.after? # invoke after hook for an old state

          state_new_block = @states[state_new]

          state_obj = Robotto::Screen.new(message, @api, session, &state_new_block)
          state_obj.instance_eval(&@global_state) if @global_state
          state_obj.build

          if state_obj.keyboard? # Invoke a keyboard if it's exists
            state_obj.build_keyboard
            state_obj.invoke_keyboard
          end

          state_obj.invoke_before if state_obj.before? #invoke before hook for a new state

          save_session session
        elsif (!state_obj.keyboard_obj.one_time? || state_obj.keyboard_obj.force_invoked?) && state_obj.keyboard?
          state_obj.build_keyboard
          state_obj.invoke_keyboard
        end
      end

      def session
        return @session if @session

        session_hash = session_exists?(chat_id) ? load(chat_id) : init_session
        session_hash[:chat] = init_chat_info.freeze if message.try(:chat)

        if start_message?
          session_hash[:state] = :start
          session_hash[:state_stack] = []
        end

        @session = session_hash
      end

      def start_message?
        if message.instance_of?(Telegram::Bot::Types::Message)
          message.text == CMD_START ? true : false
        else
          false
        end
      end

      def init_chat_info
        {
          chat_id: message.chat.id,
          description: message.chat.description,
          invite_link: message.chat.invite_link,
          title: message.chat.title,
          first_name: message.chat.first_name,
          last_name: message.chat.last_name,
          user_name: message.chat.username
        }
      end

      def init_session
        {
          state: :start,
          state_stack: [],
          keyboard_switchers: {},
          keyboard_switch_groups: {},
          lang: :default,
          chat_id: chat_id
        }
      end
    end
  end
end
