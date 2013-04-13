class ChangePrintedCdFormMapSerialNumbers < ActiveRecord::Migration
  def change
    rename_column :map_serial_numbers, :printed_cd, :activate_cd
  end
end
