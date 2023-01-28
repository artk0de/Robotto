# frozen_string_literal: true

module Robotto
  class Mongo
    include Singleton

    attr_reader :bot_name, :client

    class << self
      def client
        instance.client
      end

      def setup(bot_name, mongo_string)
        instance.setup(bot_name, mongo_string)
      end
    end

    private

    def setup(bot_name, mongo_string)
      self.bot_name = bot_name
      self.client = Mongo::Client.new(mongo_string, :database => bot_name.underscore)

      Mongo::Logger.logger.level = ::Logger::FATAL
    end

    attr_writer :bot_name, :client
  end
end
