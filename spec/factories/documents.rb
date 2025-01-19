FactoryBot.define do
  factory :document do
    title { "MyString" }
    content { "MyText" }
    association :user
    association :project
  end
end
