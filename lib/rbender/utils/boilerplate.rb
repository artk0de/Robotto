# frozen_string_literal: true

module RBender
  module Utils
    class Boilerplate
      BOILERPLATES_PATH = 'boilerplates'

      attr_reader :options, :work_dir, :boilerplates_dir

      def initialize(options)
        @options = options
        @work_dir = Dir.getwd
        @boilerplates_dir = File.expand_path(BOILERPLATES_PATH, options[:rbender_path])
      end

      def generate_project!
        check_project_name!
        # Get snake_cased project name.
        options[:project_name] = Support::ConfigHandler.underscore(options[:project_name])
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
        cp_files = %w[app config lib Gemfile .ruby-version]
        cp_files.each { |file| FileUtils.cp_r(File.join(boilerplates_dir, file), work_dir) }
      end

      def copy_ruby_version!

      end

      def create_new_dirs!
        create_dirs = %w[lib public]
        create_dirs.each { |dir| FileUtils.mkdir(dir) }
      end

      def check_project_name!
        unless options[:project_name]  =~ /\w{3,32}/
          raise ArgumentError, 'Name must be from 3 to 32 english letters without spaces'
        end
      end

      def make_project_dir!
        FileUtils.mkdir(options[:project_name])
        change_workdir!(options[:project_name])
      rescue
        puts("Project or folder named \"#{options[:project_name]}\" already exists".red)
        exit
      end

      def prepare_config!
        Support::ConfigHandler.config_path = work_dir
        config = Support::ConfigHandler.config
        config['title'] = options[:project_name]
        config.save
      end
    end
  end
end
