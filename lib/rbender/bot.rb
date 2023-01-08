# Handles bot instance.
class RBender::Bot
  include Singleton

  def initialize
    RBender::Processor::Base.new
  end
end
