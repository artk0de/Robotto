require 'yaml'

module RBender
	module ConfigHandler
		CONFIG_PATH = 'config.yaml'


		def self.underscore(str)
			str.gsub(/::/, '/').
					gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
					gsub(/([a-z\d])([A-Z])/, '\1_\2').
					tr("-", "_").
					downcase
		end

		def self.settings
			begin
				@@settings = YAML.load(File.read(CONFIG_PATH))
			rescue
				raise "Config file doesn't exists!"
			end

			def @@settings.save
				File.write(CONFIG_PATH, @@settings.to_yaml)
			end

			@@settings
		end
	end
end
