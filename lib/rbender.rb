require 'rbender/base'
require 'colorize'

module RBender
  VERSION = '0.4.82'
  @@bot = RBender::Base.new

  def self.instance
    @@bot
  end

  def self.reload
    @@bot = RBender::Base.new
  end
end


def method_missing(m, *args, &block)
  if RBender::Base.method_defined? m
    if block_given?
      if args.empty?
        RBender.instance.send(m, &block)
      else
        args = args[0] if args.count == 1
        RBender.instance.send(m, args, &block)
      end
    else
      if args.empty?
        RBender.instance.send(m)
      else
        args = args[0] if args.count == 1
        RBender.instance.send(m, args)
      end
    end
  else
      raise NoMethodError, "Method #{m} is missing!"
  end
end

