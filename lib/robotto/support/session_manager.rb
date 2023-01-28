module Robotto
  module Support
    module SessionManager
      class << self
        def chat_ids
          sessions = Robotto::Mongo.client[:sessions]
          result = sessions.distinct('chat_id')

          [].tap do |ids|
            result.each { |doc| ids << doc }
          end
        end
      end

      private

      def session_setup(mongo_client)
        @mongo_client = mongo_client
        @sessions_mongo = @mongo_client[:sessions]
      end


      # Returns user's session by chat id.
      #
      # @param chat_id [Integer] - required chat id.
      # @return [Hash] - hash with user's session.
      #
      # # # # # # # # # # # # # # # # # # # # # # # #
      # Mongo scheme:
      # Session
      # {chat_id: {session_key: session_value}}
      #
      # States
      # {chat_id: state}
      #
      # # # # # # # # # # # # # # # # # # # # # # # #
      def load(chat_id)
        result = nil

        @sessions_mongo.find(chat_id: chat_id).each do |document|
          result = document[:session]
        end

        result
      end

      def save_session(session)
        @sessions_mongo.update_one(
          { chat_id: session[:chat_id] },
          { :$set => { session: session } },
          { upsert: true }
        )
      end

      def session_exists?(chat_id)
        @sessions_mongo.find(chat_id: chat_id).count.positive?
      end
    end
  end
end
