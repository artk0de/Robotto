Gem::Specification.new do |s|
  s.name = 'robotto'
  s.version = '1.0.1'
  s.date = '2023-05-01'
  s.description = 'Gem provides domain specific language for Telegram bot creation.'
  s.authors = %w(Arthur Korochansky)
  s.email = "art2rik.desperado@gmail.com"
  s.summary = "Robotto is a tool for fast develop and test bots for Telegram."
  s.homepage = 'https://github.com/art2rik/Robotto'

  s.files = %w[MIT-LICENSE.txt README.md lib/**/* boilerplates/**/*]
  s.require_path = 'lib'

  s.metadata = { 'source_code_uri' => 'https://github.com/artk0de/robotto' }
  s.executables << 'robotto'
  s.required_ruby_version = '>= 3.1.0'

  s.add_dependency 'concurrent-ruby-edge', '~> 0.6.0'
  s.add_dependency 'telegram-bot-ruby'
  s.add_dependency 'typhoeus'
  s.add_dependency 'mongo'
  s.add_dependency 'colorize'
  s.add_dependency 'mongoid', '>= 7.4.0'
  s.add_dependency 'did_you_mean', '>= 1.6.1'
  s.add_dependency 'gli'
  s.add_dependency 'hacer'
end
