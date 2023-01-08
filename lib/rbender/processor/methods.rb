module RBender
  module Processor
    module Methods
      # Adds inline keyboard.
      #
      # @param name [String] - keyboard name.
      # @param block [Proc] - keyboard executable block.
      #
      def keyboard_inline(name, &block)
        inline_keyboard_blocks[name] = RBender::Processor::KeyboardInline.new(name, message, @session, block)
      end


      # Adds keyboard block.
      #
      # @param keyboard_block [Proc] - keyboard executable block.
      #
      def keyboard(&keyboard_block)
        raise "Global state doesn't support :keyboard method" if global?

        keyboard_obj = RBender::Processor::Keyboard.new(message)
        keyboard_obj.session = @session
        keyboard_obj.instance_eval(&keyboard_block)
      end

      # Initialize helper methods
      #
      #  @param helpers_block [Proc] - keyboard executable block.
      #
      def helpers(&helpers_block)
        if @helpers_block
          @helpers_global_block = helpers_block
        else
          @helpers_block = helpers_block
        end

        instance_eval(&helpers_block)
      end

      # Returns Inline keyboard object by name
      def inline_markup(name)
        raise "Keyboard #{name} doesn't exists!" unless inline_keyboard_blocks.member?(name)

        kb = inline_keyboard_blocks[name]

        kb.instance_eval(&@helpers_block) if @helpers_block
        kb.instance_eval(&@helpers_global_block) if @helpers_global_block

        kb.build
        kb.markup_tg
      end
    end
  end
end