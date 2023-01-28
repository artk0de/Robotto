# frozen_string_literal: true

module Robotto
  class Screen
    include Robotto::Screen::Builder
    include Robotto::Screen::Processor

    attr_reader :message, :api, :session

    class << self
      attr_reader :hook_blocks

      def inherited(subclass)
        init_block_handlers!(subclass)
      end

      def init_block_handlers!(subclass)
        default_blocks = { _klass: subclass, commands: {} }
        subclass.instance_variable_set(:@hook_blocks, default_blocks)
      end

      def global?
        !!@is_global
      end
    end

    def initialize(message, client, session)
      @message = message
      @session = session

      @client = Robotto::Processor::Methods.new(message, client, session)
    end
  end
end
