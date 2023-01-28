module Robotto
  module Support
    class QuickSettings
      include Singleton

      QUICK_SETTINGS = :quick_settings.freeze

      attr_reader :instance

      def initialize
        @config = Robotto::Mongo.client[QUICK_SETTINGS].find({ fly_settings: 1 })

        if @config.count == 0
          @config.insert_one({ "fly_settings" => 1 })
        end
      end

      def set(key, value)
        @config.update_one({ "$set" => { key => value } })
      end

      def push(key, value)
        @config.update_one({ "$push" => { key => value } }) unless list_includes?(key, value)
      end

      def get(key)
        @config.first[key]
      end

      def list_includes?(key, value)
        @config.first[key].include?(value)
      end
    end
  end
end
