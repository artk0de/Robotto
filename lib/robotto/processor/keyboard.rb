module Robotto
  module Processor
    class Keyboard
      attr_accessor :markup,
        :localizations,
        :actions,
        :response,
        :switchers,
        :markup_tg,
        :markup_final,
        :switch_groups,
        :session,
        :message

      def initialize(message)
        @message = message
        @actions = {}
        @markup = []
        @localizations = {}
        @markup_tg = nil
        @markup_final = {}
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

      def button(id, description, &action)
        @actions[id] = action
        @localizations[id] = description
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
      def line (*buttons)
        @markup += [buttons]
      end

      # Set response when keyboard is invoked
      def response=(new_response)
        @response = new_response
      end

      alias_method :make_response, :response=

      # Resize telegram buttons
      def resize
        @resize = true
      end

      # Method to initialize a keyboard
      def build
        markup = []

        @markup.each do |line|
          buf_line = []
          line.each do |button_id|
            button = @localizations[button_id].dup
            buf_line << button

            @markup_final[button_id] = button
          end

          markup << buf_line
        end

        @markup_tg =
          Telegram::Bot::Types::ReplyKeyboardMarkup.new(
            keyboard_obj: markup,
            one_time_keyboard: one_time?,
            resize_keyboard: @resize
          )
      end
    end
  end
end
