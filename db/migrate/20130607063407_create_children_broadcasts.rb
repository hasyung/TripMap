class CreateChildrenBroadcasts < ActiveRecord::Migration

  def change

    create_table :children_broadcasts do |t|
      t.references  :map,                        :null => false

      t.string      :name,                       :null => false
      #t.string     :broadcast_cover,            :null => false    # Polymorphic 'Image'
      #t.string     :broadcast_audio,            :null => false    # Polymorphic 'Audio'
      #t.string     :broadcast_desc,             :null => false    # Polymorphic 'Text'
      t.integer     :order,                      :null => false

      t.timestamps
    end

    add_index :children_broadcasts, :name, unique: true
  end

end