# frozen_string_literal: true

# Represents logic for a concrete screen.
module Robotto
  module Processor
    class ScreenDeprecated


      protected

      def chat_id
        @chat_id ||= session[:chat_id]
      end

      def command_message?
        message.text[0] == '/' && message.text != '/start'
      end



      def start_message?
        message.text == '/start'
      end
    end
  end
end
