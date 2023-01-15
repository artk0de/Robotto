# frozen_string_literal: true

module Robotto
  class Server
    def initialize(workers_count:)
      @workers_count = workers_count
    end

    def start!
      puts "Bot is loading...".green
      Telegram::Bot::Client.run(@token) do |bot|
        puts "Bot is running...\n".green
        # bot.listen { |message| @pool << message }
      end
    end

    at_exit { puts "Server stopped...".yellow.bold }
  end
end
