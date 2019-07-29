class RBender::Types::Document < RBender::Types::Base
  attribute :file_id, Types::Strict::String
  attribute :thumb, RBender::Types::PhotoSize
  attribute :file_name, Types::Maybe::Strict::String
  attribute :mime_type, Types::Maybe::Strict::String
  attribute :file_size, Types::Maybe::Strict::Integer
end