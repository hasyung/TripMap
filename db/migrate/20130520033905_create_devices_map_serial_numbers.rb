class CreateDevicesMapSerialNumbers < ActiveRecord::Migration
  def change
  	create_table :devices_map_serial_numbers do |t|
      t.references :map_serial_number,  :null => false
      t.references :device,  :null => false
      t.timestamps
    end
  end
end
