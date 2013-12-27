FactoryGirl.define do
  factory :article do
    theme
    content "article content"
    created_at Time.now
    updated_at Time.now
  end
end