# frozen_string_literal: true

class MainScreen < BotScreen
  keyboard do
    set_response 'Hello!' #response are required
    button :btn_1, 'Button 1' do
      send_message 'You have pressed Button 1'
    end

    button :btn_2, 'Button 3' do
      send_message 'You have pressed Button 2'
    end

    button :btn_3, 'Button 3' do
      send_message 'You have pressed Button 2'
    end

    line :btn_1, :btn_2
    line :btn_3
  end

  text do |text|
    send_message "You just typed:\n#{text}"
  end

  after do
    # - - - - - -
    # After hook
    # - - - - - -
  end
end
