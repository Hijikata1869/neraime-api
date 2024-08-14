FactoryBot.define do
  factory :favorite do
    association :user
    association :store
    user_id { user.id }
    store_id { store.id }
  end
end
