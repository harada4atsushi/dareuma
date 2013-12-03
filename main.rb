# coding:utf-8
require 'kaminari/sinatra'
require "omniauth"
require "omniauth-twitter"

Dir[File.join(File.dirname(__FILE__), "models", "**/*.rb")].each do |f|
  require f
end

class Main < Sinatra::Base
  register Sinatra::Reloader
  helpers Sinatra::ContentFor

  use OmniAuth::Builder do
    provider :twitter, $config["twitter"]["consumer_key"], $config["twitter"]["consumer_secret"]
  end

  configure do
    enable :sessions
    #helpers Kaminari::Helpers::SinatraHelpers
    $config = YAML.load_file( 'config.yml' )
    database = YAML.load_file( 'database.yml' )
    ActiveRecord::Base.establish_connection({
      :adapter   => database["adapter"],
      :database  => database["database"],
      :username => database["username"],
      :pool => database["pool"],
      :encoding => database["encoding"],
      :password => database["password"],
    })

    $client = Twitter::REST::Client.new do |cnf|
      cnf.consumer_key = $config["twitter"]["consumer_key"]
      cnf.consumer_secret = $config["twitter"]["consumer_secret"]
      cnf.oauth_token = $config["twitter"]["oauth_token"]
      cnf.oauth_token_secret = $config["twitter"]["oauth_token_secret"]
    end
  end

  before do
    @auth = session[:twitter]
  end

  after do
    ActiveRecord::Base.connection.close
  end

  get '/' do
    @themes = Theme.where(nil).order(:id)
    erb :index
  end

  get '/detail' do
    #user_id = request.cookies['user_id']
    #response.set_cookie("user_id", random_str) unless user_id
    id = params[:id] ? params[:id] : 1
    @theme = Theme.find(id)
    @articles = Article.where(:theme_id => id).joins("
    left outer join (select count(*) as likes_count, article_id from likes group by article_id) as likes on articles.id = likes.article_id")
      .order("likes_count desc").page(params[:page]).per(5)
    @arts = Article.where(nil).page(params[:page]).per(5)
    erb :detail
  end

  post '/detail' do
    #user_id = request.cookies['user_id'] unless user_id
    @article = Article.new(params[:article])
    @article.twitter_uid = session[:twitter][:uid] if session[:twitter]
    @article.image = session[:twitter][:image] if session[:twitter]
    @article.save
    redirect "/detail?id=#{@article.theme_id}"
  end

  get '/like' do
    begin
      #$client.update("@harada4atsushi yeah!!")
    rescue
    end
    uid = session[:twitter][:uid] if session[:twitter]
    #user_id = request.cookies['user_id'] unless user_id
    @like = Like.where(:article_id => params[:id], :user_id => uid).first
    @article = Article.where(:id => params[:id]).first
    #if @like.present?
    #  @like.destroy
    #else

    Like.create(:article_id => params[:id], :user_id => uid)
    #end
    redirect "/detail?id=#{@article.theme_id}"
  end

  get '/next' do
    @theme = Theme.where("id > ?", params[:id]).first
    redirect @theme ? "/detail?id=#{@theme.id}" : "/"
  end

  get '/prev' do
    @theme = Theme.where("id < ?", params[:id]).first
    redirect @theme ? "/detail?id=#{@theme.id}" : "/"
  end

  get "/auth/:provider/callback" do
    back_url = request.cookies['back_url'] || "/"
    auth = request.env["omniauth.auth"]
    session[:twitter] = {
      :uid => auth[:uid],
      :name => auth[:info][:name],
      :image => auth[:info][:image],
    }
    redirect back_url
  end

  post "/login" do
    response.set_cookie("back_url", params[:back_url])
    redirect "/auth/twitter"
  end

  get "/logout" do
    session[:twitter] = nil
    redirect "/detail?id=#{params[:id]}"
  end

  get "/developers" do
    erb :developers
  end

  def random_str
    a = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    code = (
      Array.new(32) do
        a[rand(a.size)]
      end
      ).join
  end
end