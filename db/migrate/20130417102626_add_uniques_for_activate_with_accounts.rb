class AddUniquesForActivateWithAccounts < ActiveRecord::Migration
  def change
  	add_index :activate_with_accounts, [:activate_map_id, :account_id], unique: true
  end
end
