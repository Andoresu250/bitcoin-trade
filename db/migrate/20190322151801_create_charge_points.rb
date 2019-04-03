class CreateChargePoints < ActiveRecord::Migration[5.2]
  def change
    create_table :charge_points do |t|
      t.references :country, foreign_key: true
      t.string :owner
      t.string :account_type
      t.string :number
      t.string :owner_identification
      t.string :iban

      t.timestamps
    end
  end
end
