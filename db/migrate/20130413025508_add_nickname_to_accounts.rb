class AddNicknameToAccounts < ActiveRecord::Migration

  def change
    add_column :accounts, :nickname, :string, limit: 30, :after => :last_sign_in_ip

    add_index :accounts, :nickname, unique: true
  end

end