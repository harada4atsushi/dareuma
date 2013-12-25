# coding:utf-8
require "./spec/spec_helper"
require "./main"

describe 'Main' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe "post /like" do
    before do
      @article = create(:article)
      post "/like/#{@article.id}"
    end

    it "likeが登録されること" do
      num = Like.where(:article_id => @article.id).count
      num.should == 1
    end
  end

=begin
  describe "post /like" do
    before do
      @article = create(:article)
      post "/like/#{@article.id}"
    end
    it "likeが登録されること" do
      num = Like.where(:article_id => @article.id).count
      num.should == 1
    end
  end
=end

end