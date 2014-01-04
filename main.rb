# coding:utf-8
require './main_config'
require './helper.rb'

before do
  session[:user] = {:cid => random_str} unless session[:user].present?
end


####################################################################
#
# フロント画面
#
####################################################################
get '/' do
  @themes = Theme.where(nil).order("order_date desc, created_at desc, id desc")
  erb :index
end

get '/theme/:id' do
  id = params[:id] ? params[:id] : 1
  @theme = Theme.find(id)
  @articles = Article.where(:theme_id => id).joins("
    left outer join (select count(*) as likes_count, article_id from likes group by article_id) as likes on articles.id = likes.article_id")
    .order("likes_count desc").page(params[:page])
  erb :theme
end

post '/theme' do
  #user_id = request.cookies['user_id'] unless user_id
  @article = Article.new(params[:article])
  @article.twitter_uid = session[:twitter][:uid] if session[:twitter]
  @article.image = session[:twitter][:image] if session[:twitter]
  @article.save
  redirect "/theme/#{@article.theme_id}"
end

delete '/article/:id' do
  article = Article.where(:id => params[:id]).first
  article.destroy
  redirect "/theme/#{article.theme_id}"
end

post '/like/:id' do
  article_id = params[:id]
  article = Article.where(:id => article_id).first
  dareuma(article_id, session[:user])
  redirect "/theme/#{article.theme_id}"
end

get '/next' do
  @theme = Theme.where("id > ?", params[:id]).first
  redirect @theme ? "/theme/#{@theme.id}" : "/"
end

get '/prev' do
  @theme = Theme.where("id < ?", params[:id]).first
  redirect @theme ? "/theme/#{@theme.id}" : "/"
end

get "/auth/:provider/callback" do
  auth = request.env["omniauth.auth"]
  session[:twitter] = {
    :uid => auth[:uid],
    :name => auth[:info][:name],
    :image => auth[:info][:image],
  }
  back_url = request.cookies['back_url'] || "/"
  redirect back_url
end

post "/login" do
  response.set_cookie("back_url", params[:back_url])
  redirect "/auth/twitter"
end

get "/logout" do
  session[:twitter] = nil
  if params[:id].present?
    redirect "/theme/#{params[:id]}"
  else
    redirect "/"
  end
end

get "/developers" do
  erb :developers
end

####################################################################
#
# 管理画面
#
####################################################################
["/admin/*", "/admin/", "/admin"].each do |route|
  before route do
    redirect "/" unless admin?
  end
end

get "/admin" do
  redirect "/admin/themes"
end

get "/admin/themes" do
  @themes = Theme.where(nil).order("order_date desc, created_at desc, id desc")
  erb "/admin/themes/index".to_sym
end

post "/admin/themes/:id" do
  theme = Theme.where(:id => params[:id]).first
  if theme.update_attributes(params[:theme])
    if params[:file]
      save_path = "./public/system/images/#{params[:id]}"
      File.open(save_path, 'wb') do |f|
        f.write params[:file][:tempfile].read
      end
    end
  end
  redirect "/admin/themes"
end


####################################################################
#
# functions
#
####################################################################
private
def dareuma(article_id, user)
  data = {:article_id => article_id}
  article = Article.where(:id => article_id).first
  likes = article.likes

  if user[:twitter_uid].present?
    likes =article.likes.where(:twitter_uid => user[:twitter_uid])
    data[:twitter_uid] = user[:twitter_uid]
  elsif user[:cid].present?
    likes = article.likes.where(:cid => user[:cid])
    data[:cid] = user[:cid]
  else
    return
  end
  like = likes.first

=begin
  if article.twitter_uid.present?
    begin
      user = $client.user(@article.twitter_uid)
      if @article.likes.count == 10
        str = "@#{user.screen_name} おめでとうございます！あなたの投稿が#{@article.likes.count}だれうま獲得しました！ "
        str << "#{$config['host']}/detail?id=#{@article.theme_id} #だれうま"
        $client.update(str)
      end
    rescue => e
      #sputs e
    end
  end
=end

  if like.present?
    like.destroy
  else
    Like.create(data)
  end
end

def random_str(len = 32)
  a = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
  code = (
    Array.new(len) do
      a[rand(a.size)]
    end
    ).join
end


=begin
 # helpersで関数まとめられる？
  helpers do
    # define a current_user method, so we can be sure if an user is authenticated
    def current_user
      !session[:uid].nil?
    end
  end

# Gemfileに定義されているgemを一括require
Bundler.require



require "db/connection.rb"
require "main_config"

# coding:utf-8
class Main < Sinatra::Base
  use MainConfig
  register Sinatra::Reloader

  before do
    @auth = session[:twitter]
    @cid = request.cookies['cid'] || random_str
    response.set_cookie("cid", @cid)
  end








end
=end