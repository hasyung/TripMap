class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.references  :textable,     :polymorphic => true
      
      t.text        :body,          :null => false      
      t.integer     :order,         :default => 0
      
      t.timestamps
    end
  end
end
