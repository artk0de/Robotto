class RBender::Types::PhotoSize < RBender::Types::Base
  attribute :file_id, Types::Strict::String
  attribute :width, Types::Strict::Integer
  attribute :height, Types::Strict::Integer
  attribute :file_size, Types::Maybe::Strict::Integer
end