class AddTypeCdForMerchants < ActiveRecord::Migration
  def change
    add_column :merchants, :type_cd, :integer, :default => 0, :after => :tag
  end
end
