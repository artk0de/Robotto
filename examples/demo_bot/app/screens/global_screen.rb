class GlobalScreen < BotScreen
  include Robotto::Screen::Global

  command '/command' do
    # command without params
  end

  command '/command2' do |params|
    # command with params
  end
end
