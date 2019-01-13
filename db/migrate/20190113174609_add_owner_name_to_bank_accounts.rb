class AddOwnerNameToBankAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :bank_accounts, :owner_name, :string
  end
end
