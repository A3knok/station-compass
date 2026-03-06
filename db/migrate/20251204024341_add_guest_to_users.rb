class AddGuestToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :guest, :boolean, default: false, null: false
    add_index :users, :guest
  end
end
