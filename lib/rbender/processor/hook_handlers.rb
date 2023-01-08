module RBender
  module Processor
    module HookHandlers
      ALLOWED_HOOKS =
        %i[
          after
          before
          contact
          checkout
          photo
          pre_checkout
          shipping
          text
        ].freeze

      private

      #
      # Some meta code. Sets service methods for hook-processing.
      #
      # # # # # # # # # # # # # # # # # # # # # # # # # # # #
      ALLOWED_HOOKS.each do |callback_name|
        block_var_name = "@#{callback_name}_block".to_sym

        # Hook processors
        define_method("process_#{callback_name}".to_sym) do
          block = instance_variable_get(block_var_name)
          instance_exec(message.contact, &block) if block
        end
      end

      #
      # Specialty invoke method, based on instance_eval.
      #
      # # # # # # # # # # # # # # # # # # # # # # # # # # # #
      [:after, :before].each do |callback_name|
        block_var_name = "@#{callback_name}_block".to_sym

        define_method("invoke_#{callback_name}".to_sym) do
          instance_eval(&instance_variable_get(block_var_name))
        end
      end

      # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

      def process_command(command_line)
        splitted = command_line.split(" ")
        command = splitted[0]
        splitted.delete_at 0
        params = splitted

        instance_exec(params, &command_blocks[command]) if @command_blocks.include?(command)
      end

      # Process if message is just text
      def process_text_message
        unless keyboard_obj.nil? # if state has keyboard
          keyboard_obj.instance_eval(&@helpers_block) if @helpers_block
          keyboard_obj.instance_eval(&@helpers_global_block) if @helpers_global_block

          build_keyboard

          keyboard_obj.markup_final.each do |btn, final_btn|
            if message.text == final_btn
              instance_exec(&keyboard_obj.actions[btn]) # Process keyboard action
              return
            end
          end
        end

        unless @text_block.nil? # Else process text action
          instance_exec(message.text, &@text_block)
        end
      end
    end
  end
end