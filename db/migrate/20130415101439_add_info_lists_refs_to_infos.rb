class AddInfoListsRefsToInfos < ActiveRecord::Migration

  def change

    remove_column :infos, :map_id

    change_table :infos do |t|
      t.references :info_list, :after => :id, :null => false
    end

    # Add index for table [infos]
    add_index :infos, :name, unique: true
    add_index :infos, :slug, unique: true
    add_index :infos, [:info_list_id, :order], unique: true

  end

end