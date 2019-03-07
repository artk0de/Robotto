class RBender::FlySettings
  include Singleton

  FLY_SETTINGS = :fly_settings.freeze

  def initialize
    @settings = RBender::MongoClient.client[FLY_SETTINGS]

    if @settings.find(fly_settings: 1).count == 0
      @settings.insert_one({"fly_settings" => 1})
    end
  end

  def set(key, value)
    @settings.update_one(fly_settings: 1, "$set" => {key: value})
  end

  def push(key, value)
    @settings.update_one(fly_settings: 1, "$push" => {key: value})
  end

  def get(key)
    @settings.find(fly_settings: 1).first[key]
  end
end