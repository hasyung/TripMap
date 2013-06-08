class EditMerchants < ActiveRecord::Migration
  def change
    add_column :merchants, :shop_hour, :string, :limit => 20, :after => :phone
    add_column :merchants, :expence, :string, :limit => 20, :after => :shop_hour
    add_column :merchants, :special, :string, :after => :expence
  end
end
