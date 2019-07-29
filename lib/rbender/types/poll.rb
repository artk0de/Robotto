class RBender::Types::Poll < RBender::Types::Base
  attribute :id, Types::Strict::String
  attribute :question, Types::Strict::String
  attribute :options, Types::Maybe::Strict::Array.of(RBender::Types::PollOption)
  attribute :is_closed, Types::Strict::Bool
end