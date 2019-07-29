class RBender::Types::ResponseParameters < RBender::Types::Base
  attribute :migrate_to_chat_id, Types::Maybe::Strict::Integer
  attribute :retry_after, Types::Maybe::Strict::Integer
end