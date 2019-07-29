class RBender::Types::InlineKeyboardMarkup < RBender::Types::Base
  attribute :keyboinline_keyboardard, Types::Array.of(Types::Array.of(RBender::Types::InlineKeyboardButton))
end