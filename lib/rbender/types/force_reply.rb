class RBender::Types::ForceReply < RBender::Types::Base
  attribute :force_reply, Types::Strict::Bool
  attribute :selective, Types::Maybe::Strict::Bool
end