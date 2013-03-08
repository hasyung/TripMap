class CreateRecommendRecords < ActiveRecord::Migration
  def change
    create_table :recommend_records do |t|
      t.references  :recommend,               :null => false
      t.string      :name,                    :null => false
      t.timestamps
    end
  end
end
