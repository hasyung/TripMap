class CreateAudioListItems < ActiveRecord::Migration

  def change

    create_table :audio_list_items do |t|
      t.references  :audio_list,                 :null => false

      t.string      :title,                      :null => false
      t.string      :abstract,                   :null => false
      t.integer     :order,                      :null => false, :default => 0
      #t.string     :audio_list_item_desc,       :null => false  # Polymorphic 'Text'
      #t.string     :audio_list_item_audio,      :null => false  # Polymorphic 'Audio'
      #t.string     :audio_list_item_icon,       :null => false  # Polymorphic 'Image'

      t.timestamps
    end

    add_index :audio_list_items, [:audio_list_id, :title, :order], unique: true
  end

end