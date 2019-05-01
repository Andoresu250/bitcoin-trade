class AddCountryToSettings < ActiveRecord::Migration[5.2]
  def change
    add_reference :settings, :country, foreign_key: true
  end
end
