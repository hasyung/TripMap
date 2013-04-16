class CreateInfoLists < ActiveRecord::Migration

  def change
    create_table :info_lists do |t|
      t.references  :map,               :null => false

      t.string      :name,              :null => false, :limit => 20
      t.string      :slug,              :null => false, :limit => 20
      t.integer     :order,             :default => 0

      t.timestamps
    end

    add_index :info_lists, [ :map_id ,:order], unique: true

  end

end