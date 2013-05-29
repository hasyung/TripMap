class AddDeviceIdToLog < ActiveRecord::Migration

  def change
    add_column :logs, :device_id, :string, :after => :activate_map_id
  end

end