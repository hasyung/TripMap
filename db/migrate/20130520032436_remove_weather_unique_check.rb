class RemoveWeatherUniqueCheck < ActiveRecord::Migration

  def change
    remove_index :weathers, :column => [:weatherable_type, :weatherable_id]
  end

end