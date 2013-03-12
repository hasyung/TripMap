class AddWidthAndHeightToImages < ActiveRecord::Migration
  def change
    add_column :images, :width,  :integer, :after => :order
    add_column :images, :height, :integer, :after => :order
  end
end
