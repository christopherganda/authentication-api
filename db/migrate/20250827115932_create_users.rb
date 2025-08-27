class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :user_id, null: false, index: { unique: true }
      t.string :password_digest, null: false
      t.string :nickname
      t.string :comment

      t.timestamps
    end
  end
end