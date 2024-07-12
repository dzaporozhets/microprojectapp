FactoryBot.define do
  factory :task do
    name { "Test Task" }
    description { "Test Task Description" }
    association :user
    association :project
  end
end
