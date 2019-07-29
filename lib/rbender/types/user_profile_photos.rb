class RBender::Types::UserProfilePhotos < RBender::Types::Base
  attribute :total_count, Types::Strict::Integer
  attribute :photos, Types::Maybe::Strict::Array.of(Types::Maybe::Strict::Array.of(RBender::Types::PhotoSize))
end