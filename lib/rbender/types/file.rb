class RBender::Types::File < RBender::Types::Base
  attribute :file_id, Types::Strict::String
  attribute :file_size, Types::Maybe::Strict::Integer
  attribute :file_path, Types::Maybe::Strict::String
end