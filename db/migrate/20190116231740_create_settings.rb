class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.decimal :last_trade_price
      t.decimal :purchase_percentage
      t.decimal :sale_percentage
      t.decimal :hour_volume
      t.integer :active_traders

      t.timestamps
    end
  end
end
