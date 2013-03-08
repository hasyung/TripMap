class CreateProvinces < ActiveRecord::Migration
  def change
    create_table :provinces do |t|
      t.string        :name,        :null => false, :limit => 20
      t.string        :slug,        :null => false, :limit => 20
      t.integer       :maps_count,  :default => 0
      t.timestamps
    end
  end
end
