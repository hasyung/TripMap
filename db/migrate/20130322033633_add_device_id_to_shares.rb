class AddDeviceIdToShares < ActiveRecord::Migration
  def change
  	add_column :shares,  :device_id, :string, :null => false, :after => :nickname
  end
end
