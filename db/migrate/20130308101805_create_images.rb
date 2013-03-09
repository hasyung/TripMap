class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references  :imageable,     :polymorphic => true
      
      t.string      :file,          :null => false
      t.string      :file_type
      t.integer     :file_size,     :default => 0
      
      t.integer     :order,         :default => 0
      
      t.integer     :group_id,      :default => 0
      t.integer     :group_order,   :default => 0
      
      t.timestamps
    end
  end
end
