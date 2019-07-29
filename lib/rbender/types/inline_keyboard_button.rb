class RBender::Types::InlineKeyboardButton < RBender::Types::Base
  attribute :text, Types::Strict::String
  attribute :url, Types::Maybe::Strict::String
  attribute :login_url, RBender::Types::LoginUrl
  attribute :callback_data, Types::Maybe::Strict::String
  attribute :switch_inline_query, Types::Maybe::Strict::String
  attribute :switch_inline_query_current_chat, Types::Maybe::Strict::String
  attribute :callback_game, RBender::Types::CallbackGame
  attribute :pay, Types::Maybe::Strict::Bool.default(false)
end