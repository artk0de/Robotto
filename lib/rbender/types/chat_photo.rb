class RBender::Types::ChatPhoto < RBender::Types::Base
  attribute :small_file_id, Types::Strict::String
  attribute :big_file_id, Types::Strict::String
end