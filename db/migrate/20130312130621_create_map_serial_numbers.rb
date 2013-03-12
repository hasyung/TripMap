class CreateMapSerialNumbers < ActiveRecord::Migration
  def change
    create_table :map_serial_numbers do |t|
      t.references  :map,               :null => false
      
      t.string  :code,                  :null => false
      t.integer :type,                  :default => 0
      t.integer :used,                  :default => 0
      
      t.timestamps
    end
  end
end
