class RBender::FlySettings
  include Singleton

  attr_reader :settings
  FLY_SETTINGS = :fly_settings.freeze

  def initialize
    @settings = RBender::MongoClient.client[FLY_SETTINGS].find({ fly_settings: 1 })

    if @settings.count == 0
      @settings.insert_one({ "fly_settings" => 1 })
    end
  end

  def set(key, value)
    @settings.update_one({ "$set" => { key => value } })
  end

  def push(key, value)
    @settings.update_one({ "$push" => { key => value } }) unless list_includes?(key, value)
  end

  def get(key)
    @settings.first[key]
  end

  def list_includes?(key, value)
    @settings.first[key].include?(value)
  end
end