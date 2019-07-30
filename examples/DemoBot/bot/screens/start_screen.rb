class StartScreen < RBender::StartScreen
  default_keyboard SelectLanguageKeyboard

  before do
    I18n.lang = if user_session['language_code'] == 'ru'
      "ru"
    else
      "en"
    end

    send_message t('welcome')
  end

  after do
    send_message t('message')
  end
end