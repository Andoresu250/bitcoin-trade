class CreateBankAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_accounts do |t|
      t.string :bank
      t.string :number
      t.string :identification
      t.references :document_type, foreign_key: true
      t.string :identification_front
      t.string :identification_back
      t.string :account_certificate
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
