# coding:utf-8
class Main < Sinatra::Base
  use MainConfig
  register Sinatra::Reloader
  helpers Sinatra::ContentFor

  before do
    @auth = session[:twitter]
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
    uid = session[:twitter][:uid] if session[:twitter]
    @article = Article.where(:id => params[:id]).first
    @like = Like.where(:article_id => params[:id], :user_id => uid).first
    Like.create(:article_id => params[:id], :user_id => uid)
    #if @like.present?
    #  @like.destroy
    #else
    #end

    if @article.twitter_uid.present?
      begin
        puts @article.likes.count
        user = $client.user(@article.twitter_uid)
        if @article.likes.count == 10
          str = "@#{user.screen_name} おめでとうございます！あなたの投稿が#{@article.likes.count}だれうま獲得しました！ "
          str << "#{$config['host']}/detail?id=#{@article.theme_id} #だれうま"
          $client.update(str)
        end
      rescue
      end
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