class AddTextTypeToTexts < ActiveRecord::Migration
  def change
    add_column :texts, :text_type, :integer, :default => 0, :after => :order
  end
end
