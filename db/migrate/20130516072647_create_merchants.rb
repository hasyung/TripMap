class CreateMerchants < ActiveRecord::Migration
  def change
    create_table :merchants do |t|
      t.references  :county,          :null => false
      t.string        :title,        :null => false, :limit => 20
      t.string        :name,        :null => false, :limit => 50
      t.string        :tag,        :limit => 50
      t.string        :address,        :null => false, :limit => 50
      t.string        :phone,        :null => false, :limit => 12
      t.text        :description,        :limit => 2000
      t.timestamps
    end

     add_index :merchants, [:county_id, :name, :address], unique: true
  end
end