class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.references  :province,          :null => false
      t.string      :name,              :null => false, :limit => 20
      t.string      :slug,              :null => true,  :limit => 20
      
      t.integer     :scenics_count,     :default => 0
      t.integer     :places_count,      :default => 0
      t.integer     :recommends_count,  :default => 0
      
      t.timestamps
    end
  end
end
