class RBender::Types::ChatMember < RBender::Types::Base
  STATUSES      = %w[creator administrator member restricted left kicked].freeze
  ADMINISTRATOR = 'administrator'.freeze
  CREATOR       = 'creator'.freeze
  KICKED        = 'kicked'.freeze
  LEFT          = 'left'.freeze
  MEMBER        = 'member'.freeze
  RESTRICTED    = 'restricted'.freeze

  attribute :user, RBender::Types::User
  attribute :status, Types::Strict::String
  attribute :until_date, Types::Maybe::Strict::Integer

  attribute :can_be_edited, Types::Maybe::Strict::Bool
  attribute :can_change_info, Types::Maybe::Strict::Bool
  attribute :can_post_messages, Types::Maybe::Strict::Bool
  attribute :can_edit_messages, Types::Maybe::Strict::Bool
  attribute :can_delete_messages, Types::Maybe::Strict::Bool
  attribute :can_invite_users, Types::Maybe::Strict::Bool
  attribute :can_restrict_members, Types::Maybe::Strict::Bool
  attribute :can_pin_messages, Types::Maybe::Strict::Bool
  attribute :can_promote_members, Types::Maybe::Strict::Bool
  attribute :is_member, Types::Maybe::Strict::Bool
  attribute :can_send_messages, Types::Maybe::Strict::Bool
  attribute :can_send_media_messages, Types::Maybe::Strict::Bool
  attribute :can_send_other_messages, Types::Maybe::Strict::Bool
  attribute :can_add_web_page_previews, Types::Maybe::Strict::Bool
end