# coding:utf-8
$:.unshift File.dirname(__FILE__) # カレントディレクトリをロードパスに追加
require "sinatra"
require 'sinatra/activerecord'
require "sinatra/content_for"
require 'omniauth-twitter'

configure do
  enable :sessions
  set :session_secret, 'hcJe1r8wVp'

  config = YAML.load_file('config.yml')
  ActiveRecord::Base.configurations = config['database']
  ActiveRecord::Base.establish_connection(ENV['RACK_ENV'])

  # modelクラスを全てrequire
  Dir[File.join(File.dirname(__FILE__), "models", "**/*.rb")].each {|f| require f }

  use OmniAuth::Builder do
    provider :twitter, config["twitter"]["consumer_key"], config["twitter"]["consumer_secret"]
  end
end

=begin
class MainConfig < Sinatra::Base

  configure do
    enable :sessions
    $config = YAML.load_file( 'config.yml' )

    $client = Twitter::REST::Client.new do |cnf|
      cnf.consumer_key = $config["twitter"]["consumer_key"]
      cnf.consumer_secret = $config["twitter"]["consumer_secret"]
      cnf.oauth_token = $config["twitter"]["oauth_token"]
      cnf.oauth_token_secret = $config["twitter"]["oauth_token_secret"]
    end
  end


end
=end