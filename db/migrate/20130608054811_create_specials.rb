class CreateSpecials < ActiveRecord::Migration
  def change
    create_table :specials do |t|
      t.references  :map, :null => false
      t.string   "name",  :limit => 20, :null => false
      t.boolean  "is_free", :default => false
      t.string   "menu_type"
      t.timestamps
    end
    add_index :specials, :name, unique: true
  end
end
