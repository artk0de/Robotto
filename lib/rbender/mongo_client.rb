require 'mongo'
require 'singleton'

class RBender::MongoClient
  include Singleton
  attr_reader :mongo_client

  public
  def self.client
    instance.mongo_client
  end

  def self.setup(bot_name, mongo_server_ip, mongo_server_port)
    instance.setup(bot_name, mongo_server_ip, mongo_server_port)
  end

  def setup(bot_name, mongo_server_ip, mongo_server_port)
    @bot_name = bot_name
    @mongo_server_ip = mongo_server_ip
    @mongo_server_port = mongo_server_port
    @mongo_client = Mongo::Client.new(["#{mongo_server_ip}:#{mongo_server_port}"], :database => bot_name)

    Mongo::Logger.logger.level = ::Logger::FATAL
  end
end
