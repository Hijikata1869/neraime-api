class CreateStores < ActiveRecord::Migration[7.1]
  def change
    create_table :stores do |t|
      t.references :prefecture, null: false, foreign_key: true
      t.string :name, null: false
      t.string :address, null: false
      
      t.timestamps
    end
  end
end
