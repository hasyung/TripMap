class AddUniquesForMaps < ActiveRecord::Migration
  
  def change
    add_index :maps, :name, unique: true
    add_index :maps, :slug, unique: true
  end
  
end