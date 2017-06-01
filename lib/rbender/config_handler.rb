require 'yaml'

module RBender
	module ConfigHandler
		@@config_path = 'config.yaml'
		CONFIG_NAME = 'config.yaml'


		def self.underscore(str)
			str.gsub(/::/, '/').
					gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
					gsub(/([a-z\d])([A-Z])/, '\1_\2').
					tr("-", "_").
					downcase
		end

		def self.settings
			begin
				@@settings = YAML.load(File.read(@@config_path))
			rescue
				raise "Config file doesn't exists!"
			end

			def @@settings.save
				File.write(@@config_path, @@settings.to_yaml)
			end

			@@settings
		end

		def self.config_path=(path)
			@@config_path = "#{path}/#{CONFIG_NAME}"
		end

		def self.token=(token)
			@@token = token
		end

		def self.token
			@@token
		end
	end
end
