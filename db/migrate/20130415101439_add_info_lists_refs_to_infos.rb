class AddInfoListsRefsToInfos < ActiveRecord::Migration

  def change

    remove_column :infos, :map_id

    change_table :infos do |t|
      t.references :info_list, :after => :id, :null => false
    end

  end

end