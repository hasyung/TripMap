class CreateActivateWithAccounts < ActiveRecord::Migration
  def change
    create_table :activate_with_accounts do |t|
      t.references  :activate_map, null: false
      t.references  :account, null: false
      t.timestamps
    end
    rename_column :shares, :nickname_id, :account_id
    add_index :activate_maps, :device_id, unique: true
  end
end
