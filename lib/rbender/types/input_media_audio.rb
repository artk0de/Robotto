class RBender::Types::InputMediaAudio < RBender::Types::InputMedia
  attribute :type, Types::Strict::String.default('audio')
  attribute :thumb, Types::Maybe::Strict::String

  attribute :duration, Types::Maybe::Strict::Integer
  attribute :performer, Types::Maybe::Strict::String
  attribute :title, Types::Maybe::Strict::String
end