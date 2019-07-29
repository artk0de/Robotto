class RBender::Types::PollOption < RBender::Types::Base
  attribute :text, Types::Strict::String
  attribute :voter_count, Types::Strict::Integer
end