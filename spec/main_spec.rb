# coding:utf-8
require "./spec/spec_helper"

describe 'Main' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe "get /like" do
    before do
      get '/like'
    end
    it "likeが登録されること" do
      like = Factory.create(:like)
      num = Like.count(nil)
      #FactoryGirl.create(:reply)
      #puts Reply.where(nil).to_yaml
      num.should == 1
    end
  end

=begin
  describe "#fav" do
    it do
      user1 = Twitter::User.new(:id => 1)
      user1.stub(:screen_name).and_return("harada4atsushi")
      user2 = Twitter::User.new(:id => 2)
      user2.stub(:screen_name).and_return("koiking__bot")
      tweet1 = Twitter::Tweet.new(:id => 10)
      tweet1.stub(:user).and_return(user1)
      tweet2 = Twitter::Tweet.new(:id => 11)
      tweet2.stub(:user).and_return(user2)

      results = Twitter::SearchResults.new
      results.stub(:statuses).and_return([tweet1, tweet2])
      Twitter.stub(:search).and_return(results)
      Twitter.stub(:favorite)
      Twitter.should_receive(:favorite).exactly(1)
      Koiking.new.fav
    end
  end
=end
end