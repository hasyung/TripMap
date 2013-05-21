class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :device_id,              :null => false
      t.timestamps
    end
    add_index :devices, :device_id, unique: true
  end
end
