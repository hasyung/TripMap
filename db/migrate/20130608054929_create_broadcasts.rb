class CreateBroadcasts < ActiveRecord::Migration

  def change
    create_table :broadcasts do |t|
      t.references  :map,                    :null => false

      t.string      :name,                   :null => false
      #t.string     :broadcast_slug,         :null => false    # Polymorphic 'Keyword'
      #t.string     :broadcast_slug_cover,   :null => false    # Polymorphic 'Image'

      t.timestamps
    end
  end

end