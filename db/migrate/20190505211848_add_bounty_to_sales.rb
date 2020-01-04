class AddBountyToSales < ActiveRecord::Migration[5.2]
  def change
    add_column :sales, :bounty, :decimal, default: 0
    add_column :sales, :bounty_percentage, :decimal, default: 0
  end
end
