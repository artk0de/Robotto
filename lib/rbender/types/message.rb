class RBender::Types::Message < RBender::Types::Base
  attribute :message_id, Types::Strict::Integer
  attribute :from, RBender::Types::User
  attribute :date, Types::Strict::Integer
  attribute :chat, RBender::Types::Chat

  attribute :forward_from, RBender::Types::User
  attribute :forward_from_chat, RBender::Types::Chat
  attribute :forward_from_message_id, Types::Maybe::Strict::Integer
  attribute :forward_signature, Types::Maybe::Strict::String
  attribute :forward_sender_name, Types::Maybe::Strict::String
  attribute :forward_date, Types::Maybe::Strict::Integer

  attribute :reply_to_message, RBender::Types::Message
  attribute :edit_date, Types::Maybe::Strict::Integer
  attribute :media_group_id, Types::Maybe::Strict::String
  attribute :author_signature, Types::Maybe::Strict::String
  attribute :text, Types::Maybe::Strict::String

  attribute :entities, Types::Maybe::Strict::Array.of(RBender::Types::MessageEntity)
  attribute :caption_entities, Types::Maybe::Strict::Array.of(RBender::Types::MessageEntity)

  attribute :audio, RBender::Types::Audio
  attribute :document, RBender::Types::Document
  attribute :animation, RBender::Types::Animation
  attribute :game, RBender::Types::Game
  attribute :photo, Types::Maybe::Strict::Array.of(RBender::Types::PhotoSize)
  attribute :sticker, RBender::Types::Sticker
  attribute :video, RBender::Types::Video
  attribute :voice, RBender::Types::Voice
  attribute :video_note, RBender::Types::VideoNote

  attribute :caption, Types::Maybe::Strict::String
  attribute :contact, RBender::Types::Contact
  attribute :location, RBender::Types::Location
  attribute :venue, RBender::Types::Venue
  attribute :poll, RBender::Types::Poll
  attribute :new_chat_members, Types::Maybe::Strict::Array.of(RBender::Types::User)
  attribute :left_chat_member, RBender::Types::User

  attribute :new_chat_title, Types::Maybe::Strict::String
  attribute :new_chat_photo, Types::Maybe::Strict::Array.of(RBender::Types::PhotoSize)

  attribute :delete_chat_photo, Types::Maybe::Strict::Bool
  attribute :group_chat_created, Types::Maybe::Strict::Bool
  attribute :supergroup_chat_created, Types::Maybe::Strict::Bool
  attribute :channel_chat_created, Types::Maybe::Strict::Bool

  attribute :migrate_to_chat_id, Types::Maybe::Strict::Integer
  attribute :migrate_from_chat_id, Types::Maybe::Strict::Integer

  attribute :pinned_message, RBender::Types::Message
  attribute :invoice, RBender::Types::Invoice
  attribute :successful_payment, RBender::Types::SuccessfulPayment

  attribute :connected_website, Types::Maybe::Strict::String
  attribute :passport_data, RBender::Types::PassportData
  attribute :reply_markup, RBender::Types::InlineKeyboardMarkup
end