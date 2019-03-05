module RBender
  module SessionManager

    private

    def session_setup(mongo_client)
      @mongo_client   = mongo_client
      @sessions_mongo = @mongo_client[:sessions]
    end

    def load_session(chat_id)
      result = nil
      @sessions_mongo.find(chat_id: chat_id).each do |document|
        result = document[:session]
      end
      result
    end

    def save_session(session)
      @sessions_mongo.update_one({ chat_id: session[:user][:chat_id] },
                                 { '$set' => { session: session } },
                                 { upsert: true })
    end

    def has_session?(chat_id)
      count = @sessions_mongo.find(chat_id: chat_id).count
      count > 0 ? true : false
    end

    public

    def self.chat_id_list
      sessions    = RBender::MongoClient.client[:sessions]
      result      = sessions.distinct('chat_id')
      chat_id_list = []
      result.each do |doc|
        chatid_list << doc
      end
      chat_id_list
    end
  end
end

# Mongo scheme:
# Session
# {chat_id: {session_key: session_value}}
#
# States
# {chat_id: state}
