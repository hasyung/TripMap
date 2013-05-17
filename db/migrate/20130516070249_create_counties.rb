class CreateCounties < ActiveRecord::Migration
  def change
    create_table :counties do |t|
      t.references  :city,          :null => false
      t.string        :name,        :null => false, :limit => 20
      t.string        :slug,        :null => false, :limit => 20
      t.integer       :merchants_count,  :default => 0
      t.timestamps
    end
    add_index :counties, :name, unique: true
    add_index :counties, :slug, unique: true
  end
end
