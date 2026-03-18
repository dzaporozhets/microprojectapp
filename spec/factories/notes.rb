FactoryBot.define do
  factory :note do
    title { "Test Note" }
    content { "Test content" }
    association :user
    association :project
  end
end
