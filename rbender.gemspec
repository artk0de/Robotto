Gem::Specification.new do |s|
  s.name        = 'rbender-bot'
  s.version     = '0.2.2.9'
  s.date        = '2016-09-23'
  s.description = 'Gem provides domain specific language for messengers bot creation.'
  s.authors     = %w(Arthur Korochansky)
  s.email       = "art2rik.desperado@gmail.com"
  s.summary     = "BenderBot is a tool for fast develop and test bots for messengers."
  s.files       = ["lib/r_bender.rb",
                   "lib/r_bender/base.rb",
                   "lib/r_bender/keyboard.rb",
                   "lib/r_bender/keyboard_inline.rb",
                   "lib/r_bender/mongo_client.rb",
                   "lib/r_bender/sessionmanager.rb",
                   "lib/r_bender/state.rb"]
  s.executables << "rbender"
end