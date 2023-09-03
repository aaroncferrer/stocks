require 'faker'

FactoryBot.define do
  factory :trader do
    first_name { "Jane" }
    last_name { "Doe" }
    email { Faker::Internet.unique.email }
    password { "password" }
    password_confirmation { "password" }

    trait :without_name do
      first_name { nil }
    end
  end
end