# frozen_string_literal: true

module Robotto
  module Utils
    class Boilerplate
      BOILERPLATES_PATH = 'boilerplates'
      CP_FILES = %w[app config lib Gemfile .ruby-version]
      MAKE_DIRS = %w[lib public]

      attr_reader :options, :work_dir, :boilerplates_dir

      def initialize(options)
        @options = options
        @work_dir = Dir.getwd
        @boilerplates_dir = File.expand_path(BOILERPLATES_PATH, options[:robotto_path])
      end

      # Generates new project folder with all required file structure and boilerplates.
      def generate_project!
        check_project_name!
        # Get snake_cased project name.
        options[:project_name] = Support::Config.underscore(options[:project_name])
        make_project_dir!
        copy_files!
        prepare_config!

        puts "Project \"#{options[:project_name] }\" successfully created".green
      end

      private

      def change_workdir!(workdir_new)
        if workdir_new.present? && workdir_new[0] == '/'
          root_dir = workdir_new.clone
          workdir_new = ''
        else
          root_dir = Dir.getwd
        end
        @work_dir = File.join(root_dir, workdir_new || '')

        FileUtils.chdir(@work_dir)
      end

      def copy_files!
        CP_FILES.each { |file| FileUtils.cp_r(File.join(boilerplates_dir, file), work_dir) }
      end

      def make_new_dirs!
        MAKE_DIRS.each { |dir| FileUtils.mkdir(dir) }
      end

      def check_project_name!
        unless options[:project_name]  =~ /\w{3,32}/
          raise ArgumentError, 'Name must be from 3 to 32 english letters without spaces'
        end
      end

      def make_project_dir!
        FileUtils.mkdir(options[:project_name])
        change_workdir!(options[:project_name])
      rescue Errno::EEXIST
        raise "Project or folder named \"#{options[:project_name].bold}\" already exists!".red
      end

      def prepare_config!
        Support::Config.config_path = work_dir
        config = Support::Config.instance
        config['title'] = options[:project_name]
        config.save
      end
    end
  end
end
