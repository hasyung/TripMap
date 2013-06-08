class ModifyChildrenBroadcastRef < ActiveRecord::Migration

  def change
    remove_column :children_broadcasts, :map_id
    add_column :children_broadcasts, :broadcast_id , :integer , :references => :broadcasts, :after => :id
  end

end