class ChangeNicknameToShares < ActiveRecord::Migration
  def up
    change_column :shares, :nickname, :integer, null: false
    rename_column :shares, :nickname, :nickname_id
  end

  def down
    change_column :shares, :nickname_id, :string, limit: 30
    rename_column :shares, :nickname_id, :nickname
  end
end
