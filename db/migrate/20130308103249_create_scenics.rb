class CreateScenics < ActiveRecord::Migration
  def change
    create_table :scenics do |t|
      t.references  :map,               :null => false
      t.string      :name,              :null => false, :limit => 20
      t.string      :slug,              :null => false, :limit => 20
      
      t.string      :temp_icon
      t.string      :temp
      
      t.timestamps
    end
  end
end
