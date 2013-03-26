class CreateRecommendDetaileds < ActiveRecord::Migration
  def change
    create_table :recommend_detaileds do |t|
      t.integer :recommend_record_id
      t.string :name
      t.integer :order

      t.timestamps
    end
  end
end
