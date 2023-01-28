# frozen_string_literal: true

module Robotto
  module Support
    module Config
      extend self
      attr_accessor :env

      CONFIG_NAME = 'config.yml'
      CONFIG_PATH = "config/#{CONFIG_NAME}"

      def underscore(str)
        str.gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
          gsub(/([a-z\d])([A-Z])/, '\1_\2').
          tr("-", "_").
          downcase
      end

      def get(key)
        instance[env][key]
      end

      def instance
        return @config if @config

        @config = YAML.load(File.read(config_path))
        @config.define_singleton_method(:save) do
          File.write(Support::Config.config_path, to_yaml)
        end

        @config
      rescue
        raise 'Config file not found!'.bold.red
      end

      def config_exist?
        File.exist?(CONFIG_PATH) && instance['title']
      end

      # Returns absolute config's path.
      # @return [String]
      def config_path
        @config_path || CONFIG_PATH
      end

      def config_path=(dir)
        @config_path = File.join(dir, CONFIG_PATH)
      end

      def token=(token)
        @token = token
      end

      def token
        @token
      end
    end
  end
end
