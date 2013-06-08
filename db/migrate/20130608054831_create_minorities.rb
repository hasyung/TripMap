class CreateMinorities < ActiveRecord::Migration
  def change
    create_table :minorities do |t|
      t.references  :special, :null => false
      t.string   "name",  :limit => 20, :null => false
      t.integer  "order", :default => 0
      t.boolean  "is_free", :default => false
      t.string   "menu_type"
      t.timestamps
    end
    add_index :minorities, :name, unique: true
  end
end
