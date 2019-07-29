class RBender::Types::InputMediaPhoto < RBender::Types::InputMedia
  attribute :type, Types::Strict::String.default('photo')
end