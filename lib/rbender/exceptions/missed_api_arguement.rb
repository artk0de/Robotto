class RBender::Exceptions::MissedApiArgument < RBender::Exceptions::Base
  attr_reader :method, :missed_args

  def initialize(method, missed_args)
    @method = method
    @missed_args = missed_args
  end

  def message
    "MissedApiArgument: missing necessary arguments (#{missed_args}) for #{method} API method."
  end
end