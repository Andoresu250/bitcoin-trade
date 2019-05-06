class AddBountyToPurchases < ActiveRecord::Migration[5.2]
  def change
    add_column :purchases, :bounty, :decimal, default: 0
    add_column :purchases, :bounty_percentage, :decimal, default: 0
  end
end
