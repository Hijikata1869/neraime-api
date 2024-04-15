class Crowdedness < ApplicationRecord
  VALID_TIME = (0..23).map { |i| "#{i}:00" }

  belongs_to :user
  belongs_to :store

  validates :day_of_week, :time, :number_of_people, :level, presence: true
  validates :day_of_week, inclusion: { in: %w(月曜日 火曜日 水曜日 木曜日 金曜日 土曜日 日曜日), message: "%{value} は無効な値です" }
  validates :time, inclusion: { in: VALID_TIME, message: "%{value} は無効な値です" }
  validates :number_of_people, inclusion: { in: %w(1人 2人 3人以上), message: "%{value} は無効な値です" }
  validates :level, inclusion: { in: %w(空いてる 普通 混雑 空き無し), message: "%{value}は無効な値です"}
  validates :memo, length: { maximum: 300 }
end