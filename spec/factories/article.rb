FactoryGirl.define do
  factory :article do
    theme
    content "article content"
    twitter_uid "12345678"
    created_at Time.now
    updated_at Time.now
  end
end