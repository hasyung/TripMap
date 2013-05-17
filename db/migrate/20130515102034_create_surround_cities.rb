class CreateSurroundCities < ActiveRecord::Migration

  def change

    create_table :surround_cities do |t|
      t.references  :map,               :null => false
      t.string      :city_name,         :null => false, :limit => 5

      t.timestamps
    end

    add_index :surround_cities, :city_name, unique: true
  end

end