class CreateFirstKnownListItems < ActiveRecord::Migration

  def change
    create_table :first_known_list_items do |t|
      t.references  :first_known_list,           :null => false

      t.integer     :order,                      :null => false, :default => 0
      t.string      :title,                      :null => false
      t.string      :description
      #t.string     :first_known_list_item_icon, :null => false    # Polymorphic 'Image'

      t.timestamps
    end

    add_index :first_known_list_items, [:first_known_list_id, :title], unique: true
  end

end