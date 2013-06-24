class CreateFights < ActiveRecord::Migration
  def change
    create_table :fights do |t|
      t.references  :county, :null => false
      t.string   :name,  :limit => 20, :null => false
      t.timestamps
    end
    add_index :fights, :name, unique: true
  end
end
