class AddUniqueIndexToPrefectures < ActiveRecord::Migration[7.1]
  def change
    add_index :prefectures, :name, unique: true
  end
end
