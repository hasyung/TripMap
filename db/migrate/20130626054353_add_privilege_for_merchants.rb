class AddPrivilegeForMerchants < ActiveRecord::Migration
  def change
    add_column :merchants, :privilege, :string, after: :expence
  end
end
