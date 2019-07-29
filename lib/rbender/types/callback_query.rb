class RBender::Types::CallbackQuery < RBender::Types::Base
  attribute :id, Types::Strict::String
  attribute :from, RBender::Types::User
  attribute :message, RBender::Types::Message
  attribute :inline_message_id, Types::Maybe::Strict::String
  attribute :chat_instance, Types::Maybe::Strict::String
  attribute :data, Types::Maybe::Strict::String
  attribute :game_short_name, Types::Maybe::Strict::String
end