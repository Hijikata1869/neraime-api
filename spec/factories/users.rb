FactoryBot.define do
  factory :user do
    nickname { "user" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
