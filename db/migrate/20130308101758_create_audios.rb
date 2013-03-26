class CreateAudios < ActiveRecord::Migration
  def change
    create_table :audios do |t|
      t.references  :audioable,     :polymorphic => true
      
      t.string      :file,          :null => false
      t.string      :file_type
      t.integer     :file_size,     :default => 0
      
      t.integer     :order,         :default => 0
      t.integer     :duration,      :default => 0
      
      t.timestamps
    end
  end
end
