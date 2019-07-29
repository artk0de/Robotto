class RBender::Types::VideoNote < RBender::Types::Base
  attribute :file_id, Types::Strict::String
  attribute :length, Types::Strict::Integer
  attribute :duration, Types::Strict::Integer
  attribute :thumb, RBender::Types::PhotoSize
  attribute :file_size, Types::Maybe::Strict::Integer
end