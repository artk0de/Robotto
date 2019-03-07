class RBender::KeyboardInline
  attr_accessor :markup_tg,
                :buttons_actions

  def initialize(name, session, block)
    @name             = name
    @buttons_callback = {}
    @buttons_inline   = {}
    @buttons_links    = {}
    @buttons_actions  = {}
    @buttons_pay      = {}
    @markup           = []
    @markup_tg        = []
    @session          = session
    @keyboard         = block
  end

  def session
    @session
  end

  # Adds button with callback
  def button(name, description, &action)
    callback                    = @name.to_s + RBender::CALLBACK_SPLITTER + name.to_s
    @buttons_callback[name]     = Telegram::Bot::Types::InlineKeyboardButton.new(text:          description,
                                                                                 callback_data: callback)
    @buttons_actions[name.to_s] = action
  end

  # Adds link button
  def button_link(name, description, link)
    @buttons_links[name] = Telegram::Bot::Types::InlineKeyboardButton.new(text: description,
                                                                          url:  link)
  end

  # Adds inline switch mode button
  def button_inline(name, description, inline_query)
    @buttons_inline[name] = Telegram::Bot::Types::InlineKeyboardButton.new(text:                description,
                                                                           switch_inline_query: inline_query)
  end

  def button_game(name, description, callback_game)
    @buttons_inline[name] = Telegram::Bot::Types::InlineKeyboardButton.new(text:                description,
                                                                           callback_game: callback_game)
  end

  # def button_callback

  def button_pay(name, description)
    @buttons_pay[name] = Telegram::Bot::Types::InlineKeyboardButton.new(text: description,
                                                                        pay: true)
  end

  # Adds a line to markup
  def line(*buttons)
    @markup += [buttons]
  end

  def invoke
    instance_eval(&@keyboard)
  end

  def build
    @markup = []
    invoke()

    buttons = {}
    buttons.merge! @buttons_callback
    buttons.merge! @buttons_links
    buttons.merge! @buttons_inline
    buttons.merge! @buttons_pay

    markup = []
    @markup.each do |btn_row|
      line = []
      btn_row.each do |btn|
        raise "The #{buttons[btn]} doesn't exists" if btn.nil?
        line << buttons[btn]
      end
      markup << line
    end
    @markup_tg = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: markup)
  end
end
