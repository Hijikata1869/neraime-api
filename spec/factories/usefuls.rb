FactoryBot.define do
  factory :useful do
    association :user
    association :crowdedness
    user_id { user.id }
    crowdedness_id { crowdedness.id }
  end
end
