module RBender
  module Processor
    module HookMethods
      # Init DSL named webhooks
      RBender::Processor::HookHandlers::ALLOWED_HOOKS.each do |callback_name|
        block_var_name = "@#{callback_name}_block".to_sym

        # Hook setters
        define_method(callback_name) do |action|
          block = instance_variable_get(block_var_name)

          raise "Too many #{callback_name} hooks!" if block

          instance_variable_set(block_var_name, action)
        end

        # Helpers like: :after?, :before?, :contact?, e.t.c...
        define_method("#{callback_name}?".to_sym) do
          !!instance_variable_get(block_var_name)
        end
      end

      def command(command, &action)
        raise("Command #{command} already exists") if @command_blocks.include? command
        raise ArgumentError.new('Command should be started from slash symbol (/).') unless command[0] == '/'

        @command_blocks[command] = action
      end

      # Adds more sugar.
      alias image photo
      alias picture photo
      alias pre_checkout_query pre_checkout
      alias successful_payment checkout
      alias payment checkout
    end
  end
end