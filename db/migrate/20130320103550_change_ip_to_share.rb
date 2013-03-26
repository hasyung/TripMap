class ChangeIpToShare < ActiveRecord::Migration
  def up
    rename_column :shares, :ip, :nickname
  end

  def down
    rename_column :shares, :nickname, :ip
  end
end
