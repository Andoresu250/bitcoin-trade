class AddBankToChargePoints < ActiveRecord::Migration[5.2]
  def change
    add_column :charge_points, :bank, :string
  end
end
