class AddImageTypeToImages < ActiveRecord::Migration
  def change
    add_column :images, :image_type, :integer, default: 0, after: :group_order
  end
end
