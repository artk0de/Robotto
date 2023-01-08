require  'rbender/processor/methods'

module RBender
  module Processor
    class StateHandler
      include RBender::Processor::HookHandlers
      include RBender::Processor::HookMethods
      include RBender::Processor::Methods

      attr_reader :keyboard_obj, :command_blocks, :message, :inline_keyboard_blocks, :api_methods, :session

      def initialize(message, api, session, &state_block)
        @message = message
        @session = session

        @api_methods = RBender::Processor::ApiMethods.new(message, api, session)
        @state_block = state_block

        @inline_keyboard_blocks = {}
        @command_blocks = {}
      end

      # Process if message is inline keyboard callback
      def process_callback
        kb_name, action = message.data.split(RBender::CALLBACK_SPLITTER)

        kb = inline_keyboard_blocks[kb_name.to_sym]
        kb.instance_eval(&@helpers_block) unless @helpers_block.nil?
        kb.invoke if keyboard?

        if keyboard? && kb.buttons_actions[action]
          instance_eval(&kb.buttons_actions[action])
        elsif keyboard
          raise "There is no action called '#{action}'"
        else
          edit_message_text(text: ':)')
        end
      end

      def build
        instance_exec(&@state_block)
      end

      def build_keyboard
        keyboard_obj.build(@session)
      end

      def invoke_keyboard
        api_methods.send_message(
          chat_id: chat_id,
          text: keyboard_obj.response,
          reply_markup: keyboard_obj.markup_tg
        )
      end

      def keyboard?
        !!keyboard_obj
      end

      protected

      def chat_id
        @chat_id ||= session[:chat_id]
      end

      def command_message?
        message.text[0] == '/' && message.text != '/start'
      end

      def global?
        @is_global
      end

      # Invokes states and processes user's input.
      def invoke
        case message
        when Telegram::Bot::Types::CallbackQuery
          process_callback
        when Telegram::Bot::Types::Message
          invoke_message
        when Telegram::Bot::Types::Document
          process_photo if message.photo
        when Telegram::Bot::Types::PreCheckoutQuery
          process_pre_checkout
        when Telegram::Bot::Types::ShippingQuery
          process_shipping
        else
          # TODO: add more entities
          raise "This type isn't available: #{message.class}"
        end
      end

      def invoke_message
        case
        when message.text
          command_message? ? process_command(message.text) : process_text_message
        when message.successful_payment
          process_checkout
        when message.contact
          process_contact
        when message.photo
          process_photo
        else
          # Nothing happens here
        end
      end

      def start_message?
        message.text == '/start'
      end

      def method_missing(m, *args, &block)
        case
        when block_given? && args.any?
          args = args[0] if args.count == 1
          api_methods.send(m, args, &block)
        when block_given?
          api_methods.send(m, &block)
        when args.any?
          args = args[0] if args.count == 1
          api_methods.send(m, args)
        else
          api_methods.send(m)
        end
      end
    end
  end
end
