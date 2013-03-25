class ChangeTypeToMapSerialNumber < ActiveRecord::Migration
  def up
    rename_column :map_serial_numbers, :type, :type_cd
    rename_column :map_serial_numbers, :printed, :printed_cd
  end

  def down
  end
end
