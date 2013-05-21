class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.references  :keywordable,     :polymorphic => true
      t.integer 	:keyword_type, :default => 0
      t.string        :slug,        :null => false, :limit => 20
    end
    add_index :keywords, :slug, unique: true
  end
end
