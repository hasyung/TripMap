class ChangeNicknameToShare < ActiveRecord::Migration
  def up
    change_column :shares, :nickname, :string, :limit => 30
  end

  def down
  end
end
