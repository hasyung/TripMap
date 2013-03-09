class CreateRecommends < ActiveRecord::Migration
  def change
    create_table :recommends do |t|
      t.references  :map,                     :null => false
      t.string      :name,                    :null => false, :limit => 20
      t.string      :slug,                    :null => false, :limit => 20
      
      t.integer     :recommend_records_count, :default => 0
      t.timestamps
    end
  end
end
