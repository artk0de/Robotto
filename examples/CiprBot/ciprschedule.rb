require 'json'

class CiprSchedule
  include Singleton

  def self.driver=(driver)
    instance.driver = driver
  end

  def driver=(driver)
    @driver = driver
    @schedule = @driver[:schedule]
  end


  def schedule(day_num)
    result = @schedule.find({day: day_num}).sort({time_start: 1})
    schedule = []
    result.each do |event|
      event["time_start"] += 3*60*60
      event["time_end"] += 3*60*60
      schedule << event
    end
    schedule
  end

  def current_day
    current_day = Time.now.utc.day

    return 0 if current_day < 7

    case current_day
      when 7; 1
      when 8; 2
      when 9; 3
      when 10; 4
      else 5
    end
  end

  def events_current
    current_time = Time.now.utc

    result = @schedule.find('$and' => [{time_start: {'$lte' => current_time}}, {time_end: {'$gte' => current_time}}])
    events = []
    result.each do |event|
      event["time_start"] += 3*60*60
      event["time_end"] += 3*60*60
      events << event
    end
    events
  end

  def events_next(day_num)
    current_time = Time.now.utc

    result = @schedule.find({time_start: {'$gt' => current_time}, day: day_num}).sort({time_start: 1}).limit(8)
    events = []
    result.each do |event|
      event["time_start"] += 3*60*60
      event["time_end"] += 3*60*60
      events << event
    end
    puts "next"
    puts "Day num #{day_num}"
    events
  end

  def load_schedule
    return if @schedule.find({}).count > 0

    Dir.chdir __dir__
    schedule = File.read 'schedule.json'
    schedule = JSON.parse schedule
    schedule.each do |event|
      time_strt = event['time']
      puts time_strt

      time_strt = Time.parse "2016 06/#{event['day'] + 6} #{time_strt} +0300"
      time_end = time_strt + 60*80
      puts "Start: #{time_strt}, End: #{time_end}}"
      @schedule.insert_one({day: event['day'],
                            time_start: time_strt,
                            time_end: time_end,
                            place: event['place'],
                            event: event['event']})
    end
  end
end

# TEST