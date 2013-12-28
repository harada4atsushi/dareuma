# coding:utf-8
$:.unshift File.dirname(__FILE__) # カレントディレクトリをロードパスに追加
require "sinatra"
require 'sinatra/activerecord'
require "sinatra/content_for"

enable :sessions
set :session_secret, 'hcJe1r8wVp'

# modelクラスを全てrequire
Dir[File.join(File.dirname(__FILE__), "models", "**/*.rb")].each {|f| require f }


=begin
class MainConfig < Sinatra::Base
  use OmniAuth::Builder do
    provider :twitter, $config["twitter"]["consumer_key"], $config["twitter"]["consumer_secret"]
  end

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