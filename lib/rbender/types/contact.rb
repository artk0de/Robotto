class RBender::Types::Contact < RBender::Types::Base
  attribute :phone_number, Types::Strict::String
  attribute :first_name, Types::Strict::String
  attribute :last_name, Types::Maybe::Strict::String
  attribute :user_id, Types::Maybe::Strict::Integer
  attribute :vcard, Types::Maybe::Strict::String
end