FactoryBot.define do
  factory :pin do
    association :user
    association :project
  end
end
