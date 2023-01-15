# frozen_string_literals = true

module Robotto
  module Support
    class ApiInfoPrinter
      TEXT_COLOR = :white
      BACKGROUND_COLOR = :cyan
      BORDER = "\s\s*\s"

      MIN_TERMINAL_WIDTH = 36
      MAX_TERMINAL_WIDTH = 115

      # * * * * * * * * * * * * * * * * * * * * * * * * *
      # * * * * * * API METHOD DOCUMENTATION * * * * * *
      # * * * * * * * * * * * * * * * * * * * * * * * *
      #
      # > send_message(
      #    chat_id: [String | Integer],
      #    text: [String] ~ MIN_LEN: 1 ~ MAX_LEN: 4096,
      #    parse_mode: [String],
      #    entities: [Array<Telegram::Bot::MessageEntity>],
      #    disable_web_page_preview: [Boolean]
      #  )
      #
      # Use this method to send text messages.
      # On success, the sent [Message](https://core.telegram.org/bots/api/#message) is returned.
      #
      # Arguments:
      #  > chat_id * (DEFAULT: )
      #
      #  Unique identifier for the target chat or username of the target channel (in the format `@channelusername`)
      #
      #  Type: Integer | String
      #
      #  Default: 40
      #
      #  Constraints:
      #     > MIN_LEN: 1
      #     > MAX_LEN 4096
      #
      #
      #  Reference: https://core.telegram.org/bots/api/#sendmessage
      #
      attr_accessor :color_mode

      def initialize(color_mode: true)
        self.color_mode = color_mode
      end

      # Forms output block for argument.
      #
      # @param argument [Hash] - argument hash from formatted TelegramBotApiSchema.
      #
      # @return [String] formed block..
      def argument_block(argument) end

      # Forms short-term string for argument.
      #
      # @param arg [Hash] - argument hash from formatted TelegramBotApiSchema.
      #
      # @return [String] formed string.
      #
      # Example output:
      #
      # "text*: [String] ~  MIN_LEN: 1 ~ MAX_LEN: 4096,"
      # "timeout: [Integer] ~  Default: 0,"
      def printable_argument_line(arg, is_error = false)
        output = arg[:required] ? arg[:name].bold + '*' : arg[:name]
        output += ': ['

        output +=
          case
          when arg[:array]
            printable_type('array', arg.dig(:array, :reference), true)
          when arg[:any_of]
            arg[:any_of].map { |a| printable_type(a[:type], a[:reference]) }.join(' | ')
          else
            printable_type(arg[:type], arg[:reference])
          end

        output += ']'

        output += " ~ Default: #{arg[:default]}" if arg[:default]
        output += " ~ MIN: #{arg[:min]}".italic if arg[:min]
        output += " ~ MAX: #{arg[:max]}".italic if arg[:max]
        output += " ~ MIN_LEN: #{arg[:min_len]}".italic if arg[:min_len]
        output += " ~ MAX_LEN: #{arg[:max_len]}".italic if arg[:max_len]
        output += " ~ ENUM: #{arg[:enum]}".italic if arg[:enum]
        output += ','

        output_styles = styles.dup
        output_styles[:color] = :red if is_error

        output.colorize(output_styles)
      end

      def print_method(method_name, short_term = false)
        schema = Robotto::Support::TelegramBotApiSchema.formatted
        method_info = schema[method_name]

        output = "#>\s#{method_name.italic}("

        method_info[:arguments].map { |arg| "#{BORDER}\s\s\s".colorize(styles) + printable_argument_line(arg) }.join(",\n")

        output += ')'

        2.times { output += "#{BORDER}\n".colorize(styles) }

        output += BORDER.colorize(styles)
      end

      def print_argument(argument_hash) end

      private

      def printable_type(type, reference = nil, is_array = false)
        output =
          case type
          when 'bool'
            'Boolean'
          when 'reference'
            reference
          else
            type.capitalize
          end

        output = "Array<#{output}>" if type == 'array'
        output.italic
      end

      def background
        color_mode? ? BACKGROUND_COLOR : :default
      end

      def text_color
        color_mode? ? TEXT_COLOR : :default
      end

      def color_mode?
        color_mode
      end

      def styles
        @styles ||= { color: text_color, background: background }
      end
    end
  end
end
