class RBender::Types::InputMediaDocument < RBender::Types::InputMedia
  attribute :type, Types::Strict::String.default('document')
  attribute :thumb, Types::Maybe::Strict::String
end