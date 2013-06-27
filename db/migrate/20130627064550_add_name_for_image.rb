class AddNameForImage < ActiveRecord::Migration

  def change
    add_column :images, :description, :string, :after => :image_type
  end

end