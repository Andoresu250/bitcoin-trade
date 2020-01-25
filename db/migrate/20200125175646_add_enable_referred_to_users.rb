class AddEnableReferredToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :enable_referred, :boolean, default: false
  end
end
