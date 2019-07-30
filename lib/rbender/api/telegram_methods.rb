require 'active_support/all'

module TelegramMethods
  API_METHODS = %i[
    getMe

    sendMessage
    forwardMessage

    sendPhoto
    sendAudio
    sendDocument
    sendVideo
    sendAnimation
    sendVoice
    sendVideoNote
    sendMediaGroup
    sendLocation

    editMessageLiveLocation
    stopMessageLiveLocation

    sendVenue
    sendContact
    sendPoll
    sendChatAction

    getUserProfilePhotos
    getFile

    kickChatMember
    unbanChatMember
    restrictChatMember
    promoteChatMember
    exportChatInviteLink
    setChatPhoto
    deleteChatPhoto
    setChatTitle
    setChatDescription
    pinChatMessage
    unpinChatMessage
    leaveChat
    getChat
    getChatAdministrators
    getChatMembersCount
    getChatMember
    setChatStickerSet
    deleteChatStickerSet
    answerCallbackQuery

    sendGame
    setGameScore
    getGameHighScores
  ].freeze

  API_INLINE_METHODS = %i[
    editMessageText
    editMessageCaption
    editMessageMedia
    editMessageReplyMarkup
    stopPoll
    deleteMessage
  ].freeze

  STICKER_METHODS = %i[
    sendSticker
    getStickerSet
    uploadStickerFile
    createNewStickerSet
    addStickerToSet
    setStickerPositionInSet
    deleteStickerFromSet
  ].freeze

  PAYMENTS_METHODS = %i[
    sendInvoice
    answerShippingQuery
    answerPreCheckoutQuery
  ]

  def send_message(text = nil, *args)
    args[:text] = text if text.present?

    call_method :sendMessage, args
  end

  def call_method(method, args)
    TelegramBot.api.execute method, args
  end

  def method_missing(m, *args, &block)
    m = ActiveSupport::Inflector.camelize(m, false)

    if (API_METHODS + API_INLINE_METHODS + STICKER_METHODS + PAYMENTS_METHODS).include? m.to_sym
      call_method m, args
    else
      raise NoMethodError, "#{m} is not Telegram Bot API method"
    end
  end
end