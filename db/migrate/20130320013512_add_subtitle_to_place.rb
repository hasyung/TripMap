class AddSubtitleToPlace < ActiveRecord::Migration
  def change
    add_column :places,  :subtitle, :string, limit: 30, :after => :slug
    add_column :scenics, :subtitle, :string, limit: 30, :after => :slug
  end
end
