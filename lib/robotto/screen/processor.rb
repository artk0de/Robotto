module Robotto
  class Screen
    module Processor
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

      def keyboard?
        !!keyboard_obj
      end

      protected

      # Invoke hook block in context of screen.
      Robotto::Screen::ALLOWED_HOOKS.each do |callback_name|
        define_method("process_#{callback_name}".to_sym) do
          block = self.class.hook_blocks[callback_name]
          instance_exec(message, message.contact, &block) if block
        end
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

      def invoke_keyboard
        api_methods.send_message(
          chat_id: chat_id,
          text: keyboard_obj.response,
          reply_markup: keyboard_obj.markup_tg
        )
      end

      def hook_blocks
        self.class.hook_blocks
      end

      # Process if message is inline keyboard callback
      def process_callback
        kb_name, action = message.data.split(Robotto::CALLBACK_SPLITTER)

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

      def process_command(command_line)
        splitted = command_line.split("\s")
        command = splitted[0]
        splitted.delete_at 0
        params = splitted

        instance_exec(params, &command_blocks[command]) if @command_blocks.include?(command)
      end

      # Process if message is just text
      def process_text_message
        if keyboard_obj # if state has keyboard
          keyboard_obj.instance_eval(&@helpers_block) if @helpers_block
          keyboard_obj.instance_eval(&@helpers_global_block) if @helpers_global_block

          build_keyboard

          # Process keyboard action
          keyboard_obj.markup_final.each do |btn, final_btn|
            return instance_exec(&keyboard_obj.actions[btn]) if message.text == final_btn
          end
        end

        instance_exec(message.text, &@text_block) if @text_block
      end
    end
  end
end
