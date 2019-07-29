class RBender::Types::Chat < RBender::Types::Base
  attribute :chat_id, Types::Strict::Integer
  attribute :type, Types::Strict::String
  attribute :title, Types::Maybe::Strict::String
  attribute :username, Types::Maybe::Strict::String
  attribute :first_name, Types::Strict::String
  attribute :last_name, Types::Maybe::Strict::String

  attribute :all_members_are_administrators, Types::Maybe::Strict::Bool
  attribute :photo, RBender::Types::ChatPhoto
  attribute :description, Types::Maybe::Strict::String
  attribute :invite_link, Types::Maybe::Strict::String
  attribute :pinned_message, RBender::Types::Message
  attribute :sticker_set_name, Types::Maybe::Strict::String
  attribute :can_set_sticker_set, Types::Maybe::Strict::Bool
end