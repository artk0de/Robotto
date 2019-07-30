class RBender::API::TelegramBot
  include RBender::API::TelegramMethods
  include Singleton

  TELEGRAM_BOT_URL = 'https://api.telegram.org/bot'

  def initialize(token)
    @token = token
  end

  def execute(method, *args)
    parse_response Faraday.post build_url(method),
                                prepare_args(args)
  end

  def build_url(method)
    "#{TELEGRAM_BOT_URL}#{@token}/#{method.to_s}"
  end

  def default_args(message, *args)
    if message.present?
      args[:chat_id] = message.chat.id if args.include? :chat_id
      args
    end

    args
  end

  def self.api
    instance
  end

  private

  def prepare_args(*args)
    args.each { |k, arg| args[k] = arg.to_json if arg.is_a? RBender::Types::Base }
  end

  def parse_response(response)

  end
end