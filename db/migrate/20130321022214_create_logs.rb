class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
    	 t.references :map,                :null => false
      t.references :activate_map,  :null => false
      t.integer :device_type_cd,  :default => 0
      t.string :slug, :null => false, :limit => 20
      t.integer :message_cd,  :default => 0
      t.timestamps
    end
  end
end
