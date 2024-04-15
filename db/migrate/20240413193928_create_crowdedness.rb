class CreateCrowdedness < ActiveRecord::Migration[7.1]
  def change
    create_table :crowdednesses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true
      t.string :day_of_week, null: false
      t.string :time, null: false
      t.string :number_of_people, null: false
      t.string :level, null: false
      t.text :memo

      t.timestamps
    end
  end
end
