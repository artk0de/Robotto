# frozen_string_literal: true

module RBender
  module Utils
    class Launcher
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
        work_dir = options.workidir || Dir.pwd
        Dir.chdir(work_dir)

        begin
          settings = RBender::ConfigHandler.config
        rescue
          puts 'Main file or config are missing!'.red
          exit
        end

        title = RBender::ConfigHandler.underscore(settings['title'])

        folders_to_req = %w[lib]
        folders_to_req.each { |folder| recursive_require("#{Dir.pwd}/#{folder}/") }

        load("#{work_dir}/#{title}.rb")

        folders_to_load = %w[screens states]
        folders_to_load.each { |folder| recursive_load("#{Dir.pwd}/#{folder}/") }

        bot_frame = RBender.instance

        #TODO: add mode setting
        RBender::Support::ConfigHandler.config_path = work_dir

        bot_frame.params(settings)
        bot_frame.run!
      end

      private

      def recursive_require(file_path)
        return unless Dir.exist?(file_path)

        Dir.foreach(file_path) do |file|
          next if file == '.' || file == '..'

          full_path = "#{file_path}/#{file}"

          if File.extname(file) == ".rb"
            require(full_path)
          elsif File.directory?(full_path)
            recursive_require(full_path)
          end
        end
      end

      def recursive_load(file_path)
        return unless Dir.exist?(file_path)

        Dir.foreach(file_path) do |file|
          next if file == "." || file == ".."

          full_path = "#{file_path}/#{file}"

          if File.extname(file) == ".rb"
            load(full_path)
          elsif File.directory? (full_path)
            recursive_load(full_path)
          end
        end
      end
    end
  end
end
