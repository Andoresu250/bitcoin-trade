class AddChargePointToCharges < ActiveRecord::Migration[5.2]
  def change
    add_reference :charges, :charge_point, foreign_key: true
  end
end
