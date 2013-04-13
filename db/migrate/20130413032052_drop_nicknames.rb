class DropNicknames < ActiveRecord::Migration
  def change
  	drop_table :nicknames
  	remove_column :activate_maps,  :map_id
  	remove_column :activate_maps,  :map_serial_number_id
  	add_column :map_serial_numbers, :account_id, :integer
  end
end
