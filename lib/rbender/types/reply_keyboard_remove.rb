class RBender::Types::ReplyKeyboardRemove < RBender::Types::Base
  attribute :remove_keyboard, Types::Strict::Bool.default(true)
  attribute :selective, Types::Maybe::Strict::Bool
end