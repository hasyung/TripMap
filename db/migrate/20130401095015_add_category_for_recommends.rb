class AddCategoryForRecommends < ActiveRecord::Migration
  def change
  	add_column :recommends, :category_cd, :integer, default: 1
  end
end
