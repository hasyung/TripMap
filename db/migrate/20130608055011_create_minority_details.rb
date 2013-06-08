class CreateMinorityDetails < ActiveRecord::Migration
  def change
    create_table :minority_details do |t|
      t.references  :minority, :null => false
      t.string   "name",  :limit => 20, :null => false
      t.integer  "order", :default => 0
      t.timestamps
    end
  end
end
