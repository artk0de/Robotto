class RBender::Types::KeyboardButton < RBender::Types::Base
  attribute :text, Types::Strict::String
  attribute :request_contact, Types::Maybe::Strict::Bool
  attribute :request_location, Types::Maybe::Strict::Bool
end