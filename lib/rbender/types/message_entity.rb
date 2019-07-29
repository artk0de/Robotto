class RBender::Types::MessageEntity < RBender::Types::Base
  attribute :type, Types::Strict::String
  attribute :offset, Types::Strict::Integer
  attribute :length, Types::Strict::Integer

  attribute :url, Types::Maybe::Strict::String
  attribute :user, RBender::Types::User
end