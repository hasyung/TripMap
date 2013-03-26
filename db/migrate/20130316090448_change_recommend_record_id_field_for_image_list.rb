class ChangeRecommendRecordIdFieldForImageList < ActiveRecord::Migration
  def up
    rename_column :image_lists, :recommend_record_id, :recommend_detailed_id
  end

  def down
    rename_column :image_lists, :recommend_detailed_id, :recommend_record_id
  end
end
