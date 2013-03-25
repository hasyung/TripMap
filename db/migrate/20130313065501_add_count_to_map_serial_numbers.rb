class AddCountToMapSerialNumbers < ActiveRecord::Migration
  
  def change
    add_column :map_serial_numbers, :count, :integer, :default => 0, :after => :used
  end
  
end
