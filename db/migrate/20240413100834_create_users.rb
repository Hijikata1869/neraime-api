class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :nickname, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.text :self_introduction
      t.timestamps
    end
  end
end
