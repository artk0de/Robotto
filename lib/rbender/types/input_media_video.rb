class RBender::Types::InputMediaVideo < RBender::Types::InputMedia
  attribute :type, Types::Strict::String.default('video')
  attribute :thumb, Types::Maybe::Strict::String

  attribute :width, Types::Maybe::Strict::Integer
  attribute :height, Types::Maybe::Strict::Integer
  attribute :duration, Types::Maybe::Strict::Integer
end