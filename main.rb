# coding:utf-8
$:.unshift File.dirname(__FILE__) # カレントディレクトリをロードパスに追加
require "sinatra"
require 'sinatra/activerecord'
require "sinatra/content_for"

# modelクラスを全てrequire
Dir[File.join(File.dirname(__FILE__), "models", "**/*.rb")].each {|f| require f }

before do
  ActiveRecord::Base.configurations = YAML.load_file('config.yml')['database']
  ActiveRecord::Base.establish_connection(ENV['RACK_ENV'])
end

get '/' do
  @themes = Theme.where(nil).order(:id)
  erb :index
end

get '/detail' do
  id = params[:id] ? params[:id] : 1
  @theme = Theme.find(id)
  @articles = Article.where(:theme_id => id).joins("
    left outer join (select count(*) as likes_count, article_id from likes group by article_id) as likes on articles.id = likes.article_id")
    .order("likes_count desc")
  @arts = Article.where(nil)
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

post '/like/:id' do
  article_id = params[:id]
  article = Article.where(:id => article_id).first
  cid = random_str
  like_toggle(article_id, cid)

=begin
  uid = session[:twitter][:uid] if session[:twitter]
  @like = @like.where(["cid = ? or twitter_uid = ?", @cid, uid]).first
  @article = Article.where(:id => article_id).first


  if @article.twitter_uid.present?
    begin
      user = $client.user(@article.twitter_uid)
      if @article.likes.count == 10
        str = "@#{user.screen_name} おめでとうございます！あなたの投稿が#{@article.likes.count}だれうま獲得しました！ "
        str << "#{$config['host']}/detail?id=#{@article.theme_id} #だれうま"
        $client.update(str)
      end
    rescue
    end
  end
=end
  redirect "/detail?id=#{article.theme_id}"
end



get '/next' do
  @theme = Theme.where("id > ?", params[:id]).first
  redirect @theme ? "/detail?id=#{@theme.id}" : "/"
end

get '/prev' do
  @theme = Theme.where("id < ?", params[:id]).first
  redirect @theme ? "/detail?id=#{@theme.id}" : "/"
end

get "/developers" do
  erb :developers
end

after do
  ActiveRecord::Base.connection.close
end

private
def like_toggle(article_id, cid)
  like = Like.where(:article_id => article_id, :cid => cid).first
  if like.present?
    like.destroy
  else
    Like.create(:article_id => article_id, :cid => cid)
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




end
=end