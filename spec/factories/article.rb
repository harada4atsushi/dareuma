FactoryGirl.define do
  factory :article do
    theme_id 1
    content "article content"
    created_at Time.now
    updated_at Time.now
  end
end