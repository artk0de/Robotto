# frozen_string_literal: true

module Robotto
  class Screen
    module Builder
      extend ActiveSupport::Concern

      class_methods do
        def command(command, &action)
          command_blocks = @hook_blocks[:commands]

          raise ArgumentError.new('Command should be started from slash symbol: f.e. /command') unless command[0] == '/'
          raise Errors::CommandDuplicateError.new(command) if command_blocks.include?(command)

          command_blocks[command] = action
        end

        # Define method for read DSL syntax from Robotto::Screen children.
        Robotto::Screen::ALLOWED_HOOKS.each do |callback_name|
          # Load callback to hash.
          define_method(callback_name) do |&block|
            if @hook_blocks[callback_name]
              raise Errors::MultipleHooksDefinitionsError.new(self.class.name, callback_name)
            else
              @hook_blocks[callback_name] = block
            end
          end
        end

        # Adds keyboard block.
        #
        # @param keyboard_block [Proc] - keyboard executable block.
        #
        def keyboard(&block)
          raise "Global state doesn't support :keyboard method" if global?

          @hook_blocks[:keyboard] = block
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

      included do
        protected

        def build_keyboard
          keyboard_obj.build(session)
        end
      end
    end
  end
end
