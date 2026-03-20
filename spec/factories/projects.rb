FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project Name #{n}" }
    association :user

    trait :with_random_name do
      name { Faker::App.name }
    end
  end
end
