class CreatePurchases < ActiveRecord::Migration[5.2]
  def change
    create_table :purchases do |t|
      t.references :person, foreign_key: true
      t.decimal :btc
      t.decimal :value
      t.references :country, foreign_key: true
      t.string :state, default: "pendiente"
      t.string :wallet_url
      t.string :evidence

      t.timestamps
    end
  end
end
