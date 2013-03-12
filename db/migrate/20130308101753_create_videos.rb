class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.references  :videoable,     :polymorphic => true
      
      t.string      :file,          :null => false
      t.string      :file_type
      t.integer     :file_size,     :default => 0
      
      t.string      :cover,         :null => false
      t.string      :cover_type
      t.integer     :cover_size,    :default => 0
      
      t.integer     :order,         :default => 0
      t.integer     :duration,      :default => 0
      
      t.timestamps
    end
  end
end
