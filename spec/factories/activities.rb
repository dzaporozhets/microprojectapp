FactoryBot.define do
  factory :activity do
    association :trackable, factory: :user
    action { 'invited' }
    association :project
    association :user
  end
end
