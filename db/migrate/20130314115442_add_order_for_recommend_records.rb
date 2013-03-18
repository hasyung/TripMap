class AddOrderForRecommendRecords < ActiveRecord::Migration
  def up
  	add_column :recommend_records, :order, :integer, :default => 0, :after => :name
  end

  def down
  end
end
