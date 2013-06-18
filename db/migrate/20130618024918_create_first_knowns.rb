class CreateFirstKnowns < ActiveRecord::Migration

  def change
    create_table :first_knowns do |t|
      t.references  :map,                             :null => false

      t.string      :name,                            :null => false
      #t.string     :first_known_slug,                :null => false    # Polymorphic 'Keyword'
      #t.string     :first_known_slug_cover,          :null => false    # Polymorphic 'Image'

      t.timestamps
    end

    add_index :first_knowns, [:map_id, :name], unique: true
  end

end