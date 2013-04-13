class CreateActivateWithAccounts < ActiveRecord::Migration
  def change
    create_table :activate_with_accounts do |t|
      t.references  :activate_maps, null: false
      t.references  :accounts, null: false
      t.timestamps
    end
    rename_column :shares, :nickname_id, :account_id
  end
end
