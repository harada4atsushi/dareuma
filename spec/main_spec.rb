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
  end

  describe "post /like" do
    it "当該お題の詳細画面に遷移すること" do
      post "/like/#{@article.id}"
      last_response.header["Location"].should include("/detail?id=#{@article.theme.id}")
    end
  end

  describe "like_toggle" do
    before do
      @cid = random_str
    end

    it "likeが登録されること" do
      like_toggle(@article.id, @cid)
      cnt = Like.where(:article_id => @article.id, :cid => @cid).count
      cnt.should == 1
    end

    context "同じユーザーが2回だれうました場合" do
      it "likeが解除され0件になること" do
        like_toggle(@article.id, @cid)
        like_toggle(@article.id, @cid)
        cnt = Like.where(:article_id => @article.id, :cid => @cid).count
        cnt.should == 0
      end
    end
  end

end