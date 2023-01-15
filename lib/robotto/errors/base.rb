# frozen_string_literal: true

module Robotto
  module Errors
    class Base < StandardError
      def initialize(msg)
        super(msg)
      end
    end
  end
end
