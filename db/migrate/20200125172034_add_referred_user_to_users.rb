class AddReferredUserToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :referred_user, foreign_key: {to_table: :users}
  end
end
