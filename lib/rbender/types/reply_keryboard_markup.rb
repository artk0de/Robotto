class RBender::Types::ReplyKeyboardMarkup < RBender::Types::Base
  attribute :keyboard, Types::Array.of(Types::Array.of(RBender::Types::KeyboardButton))
  attribute :resize_keyboard, Types::Maybe::Strict::Bool
  attribute :one_time_keyboard, Types::Maybe::Strict::Bool
  attribute :selective, Types::Maybe::Strict::Bool
end