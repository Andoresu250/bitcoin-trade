class AddBtcToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :btc, :decimal, default: 0
  end
end
