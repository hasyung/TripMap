class CreateActivateMaps < ActiveRecord::Migration
  def change
    create_table :activate_maps do |t|
      
      t.references :map,                :null => false
      t.references :map_serial_number,  :null => false
      
      t.string :device_id,              :null => false

      t.timestamps
    end
  end
end
