class AddInfosCountToInfoLists < ActiveRecord::Migration

  def change

    add_column :info_lists, :infos_count, :integer, :default => 0, :after => :order

  end

end