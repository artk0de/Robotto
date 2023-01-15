# frozen_string_literal: true

module Robotto
  class Server
    class BotWorker < Concurrent::Actor::RestartingContext
      def on_message(message)
        puts message.class
        puts message
      rescue StandardError => e
        puts e.message.red
        puts e.backtrace_locations
      end
    end
  end
end
