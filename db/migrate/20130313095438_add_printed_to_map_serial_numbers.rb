class AddPrintedToMapSerialNumbers < ActiveRecord::Migration
  def change
    add_column :map_serial_numbers, :printed, :integer, :default => 0, :after => :used
  end
end
