class AddDefaultValuesToWidthAndHeight < ActiveRecord::Migration
  def change
    change_column :images, :width, :integer, :default => 0
    change_column :images, :height, :integer, :default => 0
  end
end
