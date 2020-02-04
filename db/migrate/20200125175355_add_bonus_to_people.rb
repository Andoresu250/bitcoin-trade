class AddBonusToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :bonus, :decimal, default: 0
  end
end
