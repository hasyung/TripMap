class ChangeNicknameFromSerialToActivate < ActiveRecord::Migration
  def change
    rename_column :nicknames, :map_serial_number_id, :activate_map_id
    remove_column :shares, :device_id
  end
end
