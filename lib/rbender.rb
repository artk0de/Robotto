# frozen_string_literal: true

require 'telegram/bot'
require 'colorize'
require 'yaml'
require 'mongo'
require 'singleton'

require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/keys'

require 'rbender/processor/base'
require 'rbender/support'
require 'rbender/bot'

module RBender
  VERSION = '1.0.1'
  VERSION_NAME = 'Gamarjoba Snake'
  CALLBACK_SPLITTER = '|'

  def method_missing(m, *args, &block)
    raise NoMethodError, "Method #{m} is missing" unless RBender::Processor::HookMethods.method_defined?(m)

    case
    when block_given? && args.any?
      args = args[0] if args.count == 1
      RBender.instance.send(m, args, &block)
    when block_given?
      RBender.instance.send(m, &block)
    when args.any?
      args = args[0] if args.count == 1
      RBender.instance.send(m, args)
    else
      RBender.instance.send(m)
    end
  end

  module_function

  def print_about
    version = 'RBender version: '
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
