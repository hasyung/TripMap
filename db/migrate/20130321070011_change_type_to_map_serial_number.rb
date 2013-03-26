class ChangeTypeToMapSerialNumber < ActiveRecord::Migration
  def up
    rename_column :map_serial_numbers, :type, :type_cd
    rename_column :map_serial_numbers, :printed, :printed_cd
  end

  def down
    rename_column :map_serial_numbers, :type_cd, :type
    rename_column :map_serial_numbers, :printed_cd, :printed
  end
end
