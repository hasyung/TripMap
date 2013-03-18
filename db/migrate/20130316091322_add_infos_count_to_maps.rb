class AddInfosCountToMaps < ActiveRecord::Migration
  def change
  	add_column :maps, :infos_count, :integer, :default => 0
  end
end
