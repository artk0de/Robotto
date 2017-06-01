Gem::Specification.new do |s|
  s.name        = 'rbender'
  s.version     = '0.5.35'
  s.date        = '2017-06-01'
  s.description = 'Gem provides domain specific language for messengers bot creation.'
  s.authors     = %w(Arthur Korochansky)
  s.email       = "art2rik.desperado@gmail.com"
  s.summary     = "BenderBot is a tool for fast develop and test bots for messengers."
	s.homepage    = 'https://github.com/art2rik/RBender'
  s.files       = ["lib/rbender.rb",
                   "lib/rbender/base.rb",
                   "lib/rbender/keyboard.rb",
                   "lib/rbender/keyboard_inline.rb",
                   "lib/rbender/mongo_client.rb",
                   "lib/rbender/sessionmanager.rb",
                   "lib/rbender/state.rb",
									 "lib/rbender/methods.rb",
									 "lib/rbender/config_handler.rb",
									 "templates/locales/en.yaml",
									 "templates/config.yaml",
									 "templates/sample.rb",
									 "templates/Gemfile"]
  s.executables << "rbender"
	s.required_ruby_version = '>= 2.0.0'
end