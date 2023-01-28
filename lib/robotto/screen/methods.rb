# frozen_string_literal: true

module Robotto
  class Screen
    class Methods
      include Robotto::Support::ApiArgumentsAutoFiller
      TELEGRAM_FILE_URL = 'https://api.telegram.org/file/bot'

      attr_reader :api, :session

      def initialize(message, api, session)
        @message = message
        @session = session
        @bot_api = api
      end

      #--------------
      # User methods
      #--------------

      # Set a message user received when keyboard has invoked.
      def response=(new_response)
        @keyboard_obj.set_response(new_response)
      end

      alias set_response response=

      # Returns session hash
      def session
        @session
      end

      # Returns message object
      def message
        @real_message ||= @message.is_a?(Telegram::Bot::Types::CallbackQuery) ? @message.message : @message
      end

      def chat_id
        message.chat&.id
      end

      def switch(state_to)
        @session[:state] = state_to
      end

      def get_file(file_id:)
        result = get_file(file_id: file_id)
        result['ok'] ? result['result'] : nil
      end

      def file_path(file_id:)
        result = get_file(file_id: file_id)
        result['ok'] ? result['result']['file_path'] : nil
      end

      alias get_file_path file_path

      def upload_file(file_path)
        full_path = "#{Dir.pwd}/public/#{file_path}"
        Faraday::UploadIO.new(full_path, "multipart/form-data")
      end

      alias file upload_file
      alias upload upload_file

      def download_file(file_path:, to:)
        token = Robotto::Config.token
        path = Dir.pwd + "/public/#{to}"

        response = Typhoeus.get("#{TELEGRAM_FILES_URL}#{token}/#{file_path}")

        if response.success?
          dir = File.dirname(path)
          FileUtils.mkdir_p(dir) unless File.directory?(dir)

          File.open(path, 'wb') { |f| f.write(response.body) }
        end
      end

      alias download download_file

      private

      # Delegates api method calls to Telegram::Bot::Api object. Fills common api-method arguments.
      #
      # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
      def method_missing(method, *args)
        # Todo: Check method availability.
        # Todo: Fill Parameters
        # Todo: Validate params

        api_arguments = args.first

        api.send(method, **auto_fill_arguments(method, api_arguments))
      rescue NoMethodError
        raise Robotto::Errors::NoApiMethodError
      end
    end
  end
end
