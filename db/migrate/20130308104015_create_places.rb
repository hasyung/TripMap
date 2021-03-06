class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.references  :map,               :null => false
      t.string      :name,              :null => false, :limit => 20
      t.string      :slug,              :null => false, :limit => 20
      
      t.timestamps
    end
  end
end
