class ChangeRecomendDeteiledCountFieldForRecommendDetailed < ActiveRecord::Migration
  def up
  	rename_column :recommend_records, :recomend_deteiled_count, :recommend_detaileds_count
  end

  def down
  	rename_column :recommend_records, :recommend_detaileds_count, :recomend_deteiled_count
  end
end
