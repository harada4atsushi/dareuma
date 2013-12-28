# coding:utf-8
require "./spec/spec_helper"
require "./main"

describe 'Main' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  before do
    @article = create(:article)
    @theme = @article.theme
  end

  describe "get /theme" do
    it "お題画面に遷移すること" do
      get "/theme/#{@theme.id}"
      expect(last_response.body).to include(@theme.subject)
    end
  end

  describe "post /theme" do
    it "お題画面に遷移すること" do
      post "/theme", {:article => {
        :theme_id => @theme.id
      }}
      last_response.header["Location"].should include("/theme/#{@theme.id}")
    end
  end

  describe "post /like" do
    it "当該お題の画面に遷移すること" do
      post "/like/#{@article.id}"
      last_response.header["Location"].should include("/theme/#{@article.theme.id}")
    end
  end

  describe "dareuma" do
    before do
      @user = {:cid => random_str}
    end

    it "likeが登録されること" do
      dareuma(@article.id, @user)
      cnt = Like.where(:article_id => @article.id, :cid => @user[:cid]).count
      cnt.should == 1
    end

    it "10件だれうまされるとTwitterでリプライを投げること" do
      #10.times
    end

    context "同じユーザーが2回だれうました場合" do
      it "likeが解除され0件になること" do
        dareuma(@article.id, @user)
        dareuma(@article.id, @user)
        cnt = Like.where(:article_id => @article.id, :cid => @user[:cid]).count
        cnt.should == 0
      end
    end

    context "Twitterログインしている場合" do
      before do
        @user[:twitter_uid] = random_str
      end
      context "同じユーザーが2回だれうました場合" do
        it "likeが解除され0件になること" do
          dareuma(@article.id, @user)
          dareuma(@article.id, @user)
          cnt = Like.where(:article_id => @article.id, :twitter_uid => @user[:twitter_uid]).count
          cnt.should == 0
        end
      end
    end
  end
end