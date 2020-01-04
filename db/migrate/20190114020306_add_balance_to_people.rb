class AddBalanceToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :balance, :decimal, default: 0
  end
end
