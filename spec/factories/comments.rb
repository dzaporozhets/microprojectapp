FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraph }
    association :task
    association :user
  end
end
