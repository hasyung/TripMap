class AddSharesCountToMaps < ActiveRecord::Migration
  def change
  	add_column :maps, :shares_count, :integer, :default => 0
  end
end
