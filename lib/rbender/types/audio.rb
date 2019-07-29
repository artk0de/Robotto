class RBender::Types::Audio < RBender::Types::Base
  attribute :file_id, Types::Strict::String
  attribute :duration, Types::Strict::Integer

  attribute :performer, Types::Maybe::Strict::String
  attribute :title, Types::Maybe::Strict::String
  attribute :performime_typemer, Types::Maybe::Strict::String
  attribute :file_size, Types::Maybe::Strict::Integer
  attribute :thumb, RBender::Types::PhotoSize
end