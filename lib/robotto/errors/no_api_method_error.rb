# frozen_string_literal: true

module Robotto
  module Errors
    class NoApiMethodError < Robotto::Errors::Base
      def initialize(exception, method)

      end
    end
  end
end
