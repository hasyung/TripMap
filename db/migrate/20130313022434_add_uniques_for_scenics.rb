class AddUniquesForScenics < ActiveRecord::Migration

  def change
    add_index :scenics, :name, unique: true
    add_index :scenics, :slug, unique: true
  end

end