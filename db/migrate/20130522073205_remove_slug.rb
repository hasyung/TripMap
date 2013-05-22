class RemoveSlug < ActiveRecord::Migration
  def change
    remove_column :maps, :slug
    remove_column :scenics, :slug
    remove_column :places, :slug
    remove_column :recommends, :slug
    remove_column :info_lists, :slug
    remove_column :infos, :slug
    remove_column :merchants, :slug
  end
end
