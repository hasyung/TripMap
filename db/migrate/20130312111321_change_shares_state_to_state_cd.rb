class ChangeSharesStateToStateCd < ActiveRecord::Migration
  def change
  	 rename_column :shares, :state, :state_cd
  end
end
