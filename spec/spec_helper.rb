ENV['RACK_ENV'] = 'test'

require 'factory_girl'
require 'rspec'
require 'rack/test'
#Bundler.require

FactoryGirl.definition_file_paths = %w{./factories ./test/factories ./spec/factories}
FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.before(:all) do
    ActiveRecord::Base.configurations = YAML.load_file('config.yml')['database']
    ActiveRecord::Base.establish_connection('test')
  end
  config.after(:each) do
    ActiveRecord::Base.connection.close
  end
end