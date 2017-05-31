class RBender::Keyboard

  attr_accessor :markup,
                :localizations,
                :actions,
                :response,
                :switchers,
                :markup_tg,
                :markup_final,
                :switch_groups,
                :session

  def initialize(response)
    @response = response
    @actions = {}
    @markup = []
    @localizations = {}
    @switchers = {}
    @markup_tg = nil
    @markup_final = {}
    @switch_groups = {}
    @button_switch_group = {}
    @one_time = false
    @session = nil
    @hide_on_action = false
    @resize = false
    @force_invoke = false
  end

  def hide_on_action
    @hide_on_action = true
  end

  def force_invoked?
    @force_invoke
  end

  # Adds button to the keyboard
  #
  # Example:
  # button :btn_test, "Test button" do
  #     some_actions
  # end
  #
  # button :btn_with_loc, {ru: "Кнопка", en: "Button"} do
  #     some_actions
  # end

  def button(id, localizations, *icons, &action)
    @actions[id] = action
    @localizations[id] = localizations
  end

  # Checks keyboard one time or not
  def one_time?
    @one_time
  end

  # makes a keyboard one time
  def one_time
    @one_time = true
  end

  # Add a line to markup
  def add_line (*buttons)
    @markup += [buttons]
  end

  # Set response when keyboard is invoked
  def set_response(new_response)
    @response = new_response
  end

  # Adds switcher to buttons
  def switcher(id, *switches)
    @switchers[id] = switches
  end

  # Adds switch group
  def switch_group(group_name, *buttons)
    @switch_groups[group_name] = buttons
  end

  # Resize telegram buttons
  def resize
    @resize = true
  end

  # Adds button switch group
  def button_switch_group(button_id)
    @switch_groups.each do |group, buttons|
      if buttons.include? button_id
        return group
      end
    end
    nil
  end

  # Method to initialize a keyboard
  #
  def build(session)
    #TODO: add localization support
    markup = []
    @markup.each do |line|
      buf_line = []
      line.each do |button_id|
        btn_id = button_id # used for replacing group mask
        if @switch_groups.member? button_id # if it's switch group mask
          button_num = 0
          if session[:_keyboard_switch_groups].member? btn_id
            button_num = session[:_keyboard_switch_groups][btn_id]
          else
            session[:_keyboard_switch_groups][btn_id] = 0
          end
          button = @localizations[@switch_groups[button_id][button_num]].dup
          btn_id = @switch_groups[btn_id][button_num]
        else # if it's normal button
          button = @localizations[btn_id].dup
        end

        if @switchers.member? btn_id # Code for switcher
          switch_num = 0
          if session[:_keyboard_switchers].member? btn_id # If switcher inside session
            switch_num = session[:_keyboard_switchers][btn_id]
          else
            session[:_keyboard_switchers][btn_id] = 0 # Switcher init
          end
          switcher = @switchers[btn_id][switch_num]
          button << " " << switcher unless switcher.empty?
        end

        buf_line << button
        @markup_final[btn_id] = button
      end
      markup << buf_line
    end
    # puts @keyboard.markup_final
    @markup_tg = Telegram::Bot::Types::ReplyKeyboardMarkup
                     .new(keyboard: markup,
                          one_time_keyboard: one_time?,
                          resize_keyboard: @resize)
  end
end
