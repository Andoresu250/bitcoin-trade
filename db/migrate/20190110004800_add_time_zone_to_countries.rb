class AddTimeZoneToCountries < ActiveRecord::Migration[5.2]
  def change
    add_column :countries, :time_zone, :string
  end
end
