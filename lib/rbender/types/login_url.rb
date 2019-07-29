class RBender::Types::LoginUrl < RBender::Types::Base
  attribute :url, Types::Strict::String
  attribute :forward_text, Types::Maybe::Strict::String
  attribute :bot_username, Types::Maybe::Strict::String
  attribute :request_write_access, Types::Maybe::Strict::Bool
end