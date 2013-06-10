class CreateMinoritySlides < ActiveRecord::Migration
  def change
    create_table :minority_slides do |t|
      t.references  :minority, :null => false
      t.integer  "order", :default => 0
      t.timestamps
    end
  end
end
