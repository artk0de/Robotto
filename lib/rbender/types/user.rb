class RBender::Types::User < RBender::Types::Base
  attribute :id, Types::Strict::Integer
  attribute :is_bot, Types::Strict::Bool
  attribute :first_name, Types::Strict::String
  attribute :last_name, Types::Maybe::Strict::String
  attribute :username, Types::Maybe::Strict::String
  attribute :language_code, Types::Maybe::Strict::String
end