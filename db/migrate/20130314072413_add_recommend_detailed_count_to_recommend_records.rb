class AddRecommendDetailedCountToRecommendRecords < ActiveRecord::Migration
  def change
    add_column :recommend_records, :recomend_deteiled_count, :integer, :default => 0
  end
end
