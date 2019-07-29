class RBender::Types::Voice < RBender::Types::Base
  attribute :file_id, Types::Strict::String
  attribute :duration, Types::Strict::Integer
  attribute :mime_type, Types::Maybe::Strict::String
  attribute :file_size, Types::Maybe::Strict::Integer
end