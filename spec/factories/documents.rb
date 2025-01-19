FactoryBot.define do
  factory :document do
    title { "MyString" }
    content { "MyText" }
    user { nil }
    project { nil }
  end
end
