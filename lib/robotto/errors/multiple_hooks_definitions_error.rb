# frozen_string_literal: true

module Robotto
  module Errors
    class MultipleHooksDefinitionsError < Robotto::Errors::Base
      def initialize(klass_name, callback_name)
        super("Too many #{callback_name.bold} hook definitions in #{klass_name.underline} class!".red)
      end
    end
  end
end
