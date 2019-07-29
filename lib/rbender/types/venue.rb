class RBender::Types::Venue < RBender::Types::Base
  attribute :location, RBender::Types::Location
  attribute :title, Types::Strict::String
  attribute :address, Types::Strict::String
  attribute :foursquare_id, Types::Maybe::Strict::String
  attribute :foursquare_type, Types::Maybe::Strict::String
end