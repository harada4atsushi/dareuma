# coding:utf-8
require 'bundler/setup'
Bundler.require
require 'sinatra'
require 'sinatra/activerecord'
require 'yaml'
require 'kaminari/sinatra'
require "omniauth"
require "omniauth-twitter"

helpers Kaminari::Helpers::SinatraHelpers
config = YAML.load_file( 'config.yml' )
enable :sessions

# OmniAuth の設定
use OmniAuth::Builder do
  # Twitter の OAuth を使う
  provider :twitter, config["twitter"]["consumer_key"], config["twitter"]["consumer_secret"]
end

ActiveRecord::Base.establish_connection({
  :adapter   => "mysql2",
  :database  => "dareuma",
  :username => "root",
  :pool => 5,
  :encoding => "utf8",
})

Dir[File.join(File.dirname(__FILE__), "models", "**/*.rb")].each do |f|
  require f
end

get '/detail' do
  user_id = request.cookies['user_id']
  response.set_cookie("user_id", random_str) unless user_id
  id = params[:id] ? params[:id] : 1
  @auth = session[:twitter]
  @theme = Theme.find(id)
  @articles = Article.where(:theme_id => id).joins("
  left outer join (select count(*) as likes_count, article_id from likes group by article_id) as likes on articles.id = likes.article_id")
    .order("likes_count desc") #.page(params[:page]).per(5)
  erb :detail
end

post '/detail' do
  # TODO 投稿と同時につぶやく
  user_id = session[:twitter][:uid] if session[:twitter]
  user_id = request.cookies['user_id'] unless user_id
  #user_id = 
  @article = Article.new(params[:article])
  @article.user_id = user_id
  @article.image = session[:twitter][:image] if session[:twitter]
  @article.save
  redirect "/detail?id=#{@article.theme_id}"
end

get '/like' do
  user_id = session[:twitter][:uid] if session[:twitter]
  user_id = request.cookies['user_id'] unless user_id
  @like = Like.where(:article_id => params[:id], :user_id => user_id).first
  @article = Article.where(:id => params[:id]).first
  if @like.present?
    @like.destroy
  else
    Like.create(:article_id => params[:id], :user_id => user_id)
  end
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

get '/' do
  @themes = Theme.where(nil).order(:id)
  erb :top
end

# Twitter の認証が成功したら呼び出される
get "/auth/:provider/callback" do
  # 認証情報は request.env に格納されている
  theme_id = request.cookies['theme_id']
  auth = request.env["omniauth.auth"]
  puts auth[:info][:image].to_yaml
  session[:twitter] = {
    :uid => auth[:uid],
    :name => auth[:info][:name],
    :image => auth[:info][:image],
  }
  redirect "/detail?id=#{theme_id}"
end

get "/login" do
  response.set_cookie("theme_id", params[:id])
  redirect "/auth/twitter"
end

get "/logout" do
  session[:twitter] = nil
  redirect "/detail?id=#{params[:id]}"
end

def random_str 
  a = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
  code = (
    Array.new(32) do
      a[rand(a.size)]
    end
    ).join
end
