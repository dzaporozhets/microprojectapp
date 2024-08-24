FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "Task Name #{n}" }
    description { "Test Task Description" }
    association :user
    association :project

    trait :with_random_name do
      name { Faker::Name.unique.name }
    end
  end
end
