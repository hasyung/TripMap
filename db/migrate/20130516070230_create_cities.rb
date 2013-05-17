class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string        :name,        :null => false, :limit => 20
      t.string        :slug,        :null => false, :limit => 20
      t.integer       :counties_count,  :default => 0
      t.timestamps
    end
    add_index :cities, :name, unique: true
    add_index :cities, :slug, unique: true
  end
end
