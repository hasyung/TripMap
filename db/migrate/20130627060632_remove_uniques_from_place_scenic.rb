class RemoveUniquesFromPlaceScenic < ActiveRecord::Migration

  def change
    remove_index :scenics, :column => [:name]
    remove_index :places,  :column => [:name]
  end

end