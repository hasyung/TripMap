class AddInfoListsCountToMaps < ActiveRecord::Migration

  def change
    remove_column :maps, :infos_count

    add_column :maps, :info_lists_count, :integer, :default => 0, :after => :recommends_count
  end

end