class CreateInfos < ActiveRecord::Migration
  def change
    create_table :infos do |t|
    	t.references  :map,               :null => false
    	t.string        :name,        :null => false, :limit => 20
    	t.string      :slug,              :null => false, :limit => 20
    	t.integer     :order,         :default => 0
      t.timestamps
    end
  end
end
