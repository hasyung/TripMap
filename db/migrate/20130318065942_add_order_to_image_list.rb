class AddOrderToImageList < ActiveRecord::Migration
  def change
    add_column :image_lists, :order, :integer, :default => 0, :after => :name
    remove_column :images, :group_id
    remove_column :images, :group_order
    change_column :recommend_detaileds, :order, :integer, :default => 0
  end
end
