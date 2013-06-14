class CreateAudioListCategories < ActiveRecord::Migration

  def change
    create_table :audio_list_categories do |t|
      t.references  :map,                             :null => false

      t.string      :name,                            :null => false
      #t.string     :audio_list_category_slug,        :null => false    # Polymorphic 'Keyword'
      #t.string     :audio_list_category_slug_cover,  :null => false    # Polymorphic 'Image'

      t.timestamps
    end

    add_index :audio_list_categories, :name, unique: true
  end

end