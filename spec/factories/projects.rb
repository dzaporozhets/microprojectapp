FactoryBot.define do
  factory :project do
    name { "Test Project" }
    association :user

    trait :with_random_name do
      name { Faker::App.name }
    end

    trait :with_files do
      after(:build) do |project|
        project.project_files = [
          Rack::Test::UploadedFile.new(
            Rails.root.join('spec/fixtures/files/test_file.txt'),
            'text/plain'
          )
        ]
      end
    end
  end
end
