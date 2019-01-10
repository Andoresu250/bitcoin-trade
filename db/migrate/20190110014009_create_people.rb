class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :first_names
      t.string :last_names
      t.string :identification
      t.references :document_type, foreign_key: true
      t.references :country, foreign_key: true
      t.string :phone
      t.string :identification_front
      t.string :identification_back
      t.string :public_receipt

      t.timestamps
    end
  end
end
