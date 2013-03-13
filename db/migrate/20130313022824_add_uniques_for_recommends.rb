class AddUniquesForRecommends < ActiveRecord::Migration
  
  def change
    add_index :recommends, :name, unique: true
    add_index :recommends, :slug, unique: true
  end
  
end