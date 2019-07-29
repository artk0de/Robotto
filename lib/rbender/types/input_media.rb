class RBender::Types::InputMedia < RBender::Types::Base
  attribute :media, Types::Strict::String
  attribute :caption, Types::Maybe::Strict::String
  attribute :pase_mode, Types::Maybe::Strict::String
end