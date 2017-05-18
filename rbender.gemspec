Gem::Specification.new do |s|
  s.name        = 'rbender-bot'
  s.version     = '0.3'
  s.date        = '2017-05-18'
  s.description = 'Gem provides domain specific language for messengers bot creation.'
  s.authors     = %w(Arthur Korochansky)
  s.email       = "art2rik.desperado@gmail.com"
  s.summary     = "BenderBot is a tool for fast develop and test bots for messengers."
  s.files       = ["lib/rbender.rb",
                   "lib/rbender/base.rb",
                   "lib/rbender/keyboard.rb",
                   "lib/rbender/keyboard_inline.rb",
                   "lib/rbender/mongo_client.rb",
                   "lib/rbender/sessionmanager.rb",
                   "lib/rbender/state.rb"]
  s.executables << "rbender"
end