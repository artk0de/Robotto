# frozen_string_literal: true

module Robotto
  module Errors
    class CommandDuplicateError < Robotto::Errors::Base
      def initialize(command)
        super("Command already defined: #{command.underline}".red)
      end
    end
  end
end
