FactoryBot.define do
  factory :store do
    sequence(:name) { |n| "store#{n}" }
    sequence(:address) { |n| "address#{n}"}
    association :prefecture
  end
end
