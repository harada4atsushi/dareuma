# coding:utf-8
$:.unshift File.dirname(__FILE__) # カレントディレクトリをロードパスに追加
Bundler.require

configure do
  enable :sessions
  set :session_secret, 'hcJe1r8wVp'

  config = YAML.load_file('config.yml')
  set :config, config

  ActiveRecord::Base.configurations = config['database']
  ActiveRecord::Base.establish_connection(ENV['RACK_ENV'])

  # modelクラスを全てrequire
  Dir[File.join(File.dirname(__FILE__), "models", "**/*.rb")].each {|f| require f }

  use OmniAuth::Builder do
    provider :twitter, config["twitter"]["consumer_key"], config["twitter"]["consumer_secret"]
  end

  register Kaminari::Helpers::SinatraHelpers

  # kaminariがI18nを利用しており、yamlのエラーが発生するための対策
  I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
  I18n.locale = :ja
end