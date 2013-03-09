class AddOrderToRecommendRecords < ActiveRecord::Migration
  def change
  	add_column   :recommend_records, :order, :integer, :default => 0
  end
end
