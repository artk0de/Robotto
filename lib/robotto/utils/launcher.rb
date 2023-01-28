# frozen_string_literal: true

module Robotto
  module Utils
    class Launcher
      FOLDERS_LOAD = %w[app]
      FOLDERS_REQUIRE = %w[lib]

      attr_reader :options

      class << self
        def start!(options)
          new(options).start!
        end
      end

      def initialize(options)
        @options = options
      end

      def start!
        prepare_config
        load_files

        Robotto::Server.new(workers_count: Robotto::Support::Config.get('workers') || 1).start!
      end

      private

      def load_files
        FOLDERS_REQUIRE.each { |folder| recursive_require("#{Dir.pwd}/#{folder}/") }
        FOLDERS_LOAD.each { |folder| recursive_load("#{Dir.pwd}/#{folder}/") }
      end

      def prepare_config
        Support::Config.config_path = options[:work_dir]
        Support::Config.env = options[:env]
        Support::Config.instance
      end

      def recursive_require(file_path)
        return unless Dir.exist?(file_path)

        Dir.foreach(file_path) do |file_name|
          next if file_name == '.' || file_name == '..'

          full_path = File.join(file_path, file_name)

          if File.extname(file_name) == ".rb"
            require(full_path)
          elsif File.directory?(full_path)
            recursive_require(full_path)
          end
        end
      end

      def recursive_load(file_path)
        return unless Dir.exist?(file_path)

        Dir.foreach(file_path) do |file_name|
          next if file_name == "." || file_name == ".."

          full_path = File.join(file_path, file_name)

         if File.extname(file_name) == ".rb"
            load(full_path)
          elsif File.directory? (full_path)
            recursive_load(full_path)
          end
        end
      end
    end
  end
end
