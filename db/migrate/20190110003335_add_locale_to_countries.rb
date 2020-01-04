class AddLocaleToCountries < ActiveRecord::Migration[5.2]
  def change
    add_column :countries, :locale, :string
  end
end
