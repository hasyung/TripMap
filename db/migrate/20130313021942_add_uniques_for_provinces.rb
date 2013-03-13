class AddUniquesForProvinces < ActiveRecord::Migration
  
  def change
    add_index :provinces, :name, unique: true
    add_index :provinces, :slug, unique: true
  end
  
end