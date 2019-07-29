class RBender::Types::Video < RBender::Types::Base
  attribute :file_id, Types::Strict::String
  attribute :width, Types::Strict::Integer
  attribute :height, Types::Strict::Integer
  attribute :duration, Types::Strict::Integer

  attribute :thumb, RBender::Types::PhotoSize
  attribute :mime_type, Types::Maybe::Strict::String
  attribute :file_size, Types::Maybe::Strict::Integer
end