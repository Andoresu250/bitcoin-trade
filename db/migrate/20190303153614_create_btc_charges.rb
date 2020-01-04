class CreateBtcCharges < ActiveRecord::Migration[5.2]
  def change
    create_table :btc_charges do |t|
      t.references :person, foreign_key: true
      t.decimal :btc
      t.string :state
      t.string :evidence
      t.string :qr

      t.timestamps
    end
  end
end
