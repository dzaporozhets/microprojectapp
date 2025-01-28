FactoryBot.define do
  factory :note do
    title { "MyString" }
    content { "MyText" }
    association :user
    association :project
  end
end
