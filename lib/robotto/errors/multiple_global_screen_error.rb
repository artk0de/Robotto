# frozen_string_literal: true

module Robotto
  module Errors
    class MultipleGlobalScreenError < Robotto::Errors::Base
      def initialize(klass_name)
        super("Global screen already defined in: #{klass_name.underline}".red)
      end
    end
  end
end
