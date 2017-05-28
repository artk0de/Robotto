require 'mongo'
require 'singleton'

class RBender::MongoClient
  include Singleton
  attr_reader :mongo_client

  public
  def self.client
    instance.mongo_client
  end

  def self.setup(bot_name, mongo_string)
    instance.setup(bot_name, mongo_string)
  end

  def setup(bot_name, mongo_string)
    @bot_name = bot_name
    @mongo_client = Mongo::Client.new(mongo_string, :database => bot_name)

    Mongo::Logger.logger.level = ::Logger::FATAL
  end
end
