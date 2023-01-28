# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# ------------------------------------------------------------------- #
#  Provides auto substitution for missing parameters in Api requests. #
# ------------------------------------------------------------------- #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

module Robotto
  module Support
    module ApiArgumentsAutoFiller
      FILLABLE_ARGUMENTS =
        {
          callback_query_id: proc { message.id },
          chat_id: proc { chat_id },
          disable_notification: false,
          message_id: proc { message.message_id },
        }.freeze

      # Fills missed defined arguments
      def auto_fill_arguments(method, arguments)
        return arguments if arguments.blank?

        schema = Robotto::Support::TelegramBotApiSchema.formatted
        available_arguments = schema.dig(method, :arguments_list)
        missed_arguments = available_arguments - arguments.keys

        to_fill = FILLABLE_ARGUMENTS.keys & missed_arguments
        to_fill.each { |a| arguments[a] = (value = FILLABLE_ARGUMENTS[a].is_a? Proc) ? value.call : value }

        arguments.to_a
      end

      # TODO: feature to add default arguments from bots' code.
    end
  end
end
