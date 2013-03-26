class AddUniquesForPlaces < ActiveRecord::Migration
  
  def change
    add_index :places, :name, unique: true
    add_index :places, :slug, unique: true
  end
  
end
