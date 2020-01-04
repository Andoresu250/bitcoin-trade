class AddMoneyCodeToCountries < ActiveRecord::Migration[5.2]
  def change
    add_column :countries, :money_code, :string, default: "COP"
    add_column :countries, :symbol, :string, default: "$"
  end
end
