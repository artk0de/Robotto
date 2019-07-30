class SelectLanguageKeyboard < RBender::Keyboard
  button :ru do
    set_lang(:ru)
    switch MainScreen
  end

  button :en do
    set_lang(:en)
    switch MainScreen
  end

  markup do
    line :ru
    line :en
  end

  private

  def set_lang(lang)
    session[:language] = lang
  end
end