class CreateUsefuls < ActiveRecord::Migration[7.1]
  def change
    create_table :usefuls do |t|
      t.references :user, null: false, foreign_key: true
      t.references :crowdedness, null: false, foreign_key: true

      t.timestamps
    end

    add_index :usefuls, [:user_id, :crowdedness_id], unique: true
  end
end
