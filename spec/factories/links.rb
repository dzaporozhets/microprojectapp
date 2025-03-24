FactoryBot.define do
  factory :link do
    title { "Test Link" }
    url { "http://example.com" }
    association :user
    association :project
  end
end
