class CreateImageLists < ActiveRecord::Migration
  def change
    create_table :image_lists do |t|
      t.references  :recommend_record,               :null => false
      t.string      :name,                           :null => false
      t.timestamps
    end
  end
end
