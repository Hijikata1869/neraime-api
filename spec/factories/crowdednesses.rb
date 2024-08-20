FactoryBot.define do
  factory :crowdedness do
    association :user
    association :store
    day_of_week { "月曜日" }
    time { "0:00" }
    level { "空いてる" }
  end
end
