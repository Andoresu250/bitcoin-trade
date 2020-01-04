class CreateTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :tokens do |t|
      t.string :token
      t.integer :user_id
      t.datetime :expires_at

      t.timestamps null: false
    end

    add_index :tokens, :user_id
  end
end
