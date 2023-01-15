# frozen_string_literal: true

require 'active_support/core_ext/object'
require 'active_support/core_ext/hash'
require 'active_support/concern'
require 'colorize'
require 'concurrent-edge'
require 'mongo'
require 'singleton'
require 'telegram/bot'
require 'yaml'
require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.setup # ready!

module Robotto
  VERSION = '1.0.1'
  VERSION_NAME = 'Gamarjoba Snake'
  CALLBACK_SPLITTER = '|'

  def method_missing(m, *args, &block) # <------------------   ? ? ? ? ? ? ?  ? ?
    raise NoMethodError, "Method #{m} is missing" unless Robotto::Processor::HookMethods.method_defined?(m)

    case
    when block_given? && args.any?
      args = args[0] if args.count == 1
      Robotto::Bot.instance.send(m, args, &block)
    when block_given?
      Robotto::Bot.instance.send(m, &block)
    when args.any?
      args = args[0] if args.count == 1
      Robotto::Bot.instance.send(m, args)
    else
      Robotto::Bot.instance.send(m)
    end
  end

  module_function

  def print_about
    version = 'Robotto version: '
    version += %{#{VERSION.yellow} }
    version += %{"#{VERSION_NAME}"\n\n}
    puts version

    author = 'Author: Arthur '
    author += 'Art'.green
    author += 'K'.red
    author += '0'.blue
    author += 'DE'.red
    author += ' Korochansky'
    author += "\nGitHub: https://github.com/artk0de"
    puts author
  end
end

loader.inflector.inflect("allowed_hooks" => "ALLOWED_HOOKS")
loader.eager_load # optionally

