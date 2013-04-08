class CreateIpAddresses < ActiveRecord::Migration
  def change
    create_table :ip_addresses do |t|
    	t.string :ip, null: false
    	t.integer :counter, default: 1
      t.timestamps
    end
  end
end
