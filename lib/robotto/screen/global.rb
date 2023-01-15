# frozen_string_literal: true

module Robotto
  class Screen
    module Global
      extend ActiveSupport::Concern
      @@klass_name = nil

      included do
        raise Errors::MultipleGlobalScreenError.new(@@klass_name) if @@klass_name

        @@klass_name = self.name
        @is_global = true
      end

      module_function

      def global_screen_klass
        @klass_name.constantize
      end
    end
  end
end
