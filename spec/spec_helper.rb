require "yaml"
require "active_record"
require "twitter"
require "factory_girl"
require 'rack/test'
Bundler.require

ActiveRecord::Base.configurations = YAML.load_file('config.yml')['database']
ActiveRecord::Base.establish_connection('test')

Dir[File.join(File.dirname(__FILE__), "..", "models", "*.rb")].each do |f|
  require f
end

Dir[File.join(File.dirname(__FILE__), "..", "factories", "*.rb")].each do |f|
  require f
end
