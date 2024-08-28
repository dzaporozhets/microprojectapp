FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }

    trait :admin do
      admin { true }
    end

    trait :google do
      uid { '12345678' }
      provider { 'google_oauth2' }
      created_from_oauth { true }
    end

    trait :msft do
      uid { '0000-0000-abcd-12345678' }
      provider { 'azure_activedirectory_v2' }
      created_from_oauth { true }
    end
  end
end
