# coding:utf-8
class MainConfig < Sinatra::Base
  use OmniAuth::Builder do
    provider :twitter, $config["twitter"]["consumer_key"], $config["twitter"]["consumer_secret"]
  end

  configure do
    enable :sessions
    $config = YAML.load_file( 'config.yml' )

    ActiveRecord::Base.configurations = YAML.load_file('database.yml')
    ActiveRecord::Base.establish_connection('development')

    $client = Twitter::REST::Client.new do |cnf|
      cnf.consumer_key = $config["twitter"]["consumer_key"]
      cnf.consumer_secret = $config["twitter"]["consumer_secret"]
      cnf.oauth_token = $config["twitter"]["oauth_token"]
      cnf.oauth_token_secret = $config["twitter"]["oauth_token_secret"]
    end
  end

  after do
    ActiveRecord::Base.connection.close
  end
end