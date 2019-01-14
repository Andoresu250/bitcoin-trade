class CreateCharges < ActiveRecord::Migration[5.2]
  def change
    create_table :charges do |t|
      t.references :person, foreign_key: true
      t.decimal :amount
      t.string :state, default: "pendiente"
      t.string :evidence

      t.timestamps
    end
  end
end
