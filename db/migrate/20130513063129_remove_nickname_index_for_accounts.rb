class RemoveNicknameIndexForAccounts < ActiveRecord::Migration
  def up
  	remove_index :accounts, :nickname
  end

  def down
  	add_index :accounts, :nickname, unique: true
  end
end
