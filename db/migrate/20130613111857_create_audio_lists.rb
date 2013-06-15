class CreateAudioLists < ActiveRecord::Migration

  def change
    create_table :audio_lists do |t|
      t.references  :audio_list_category,        :null => false

      t.string      :name,                       :null => false
      #t.string     :audio_list_icon,            :null => false    # Polymorphic 'Image'
      t.string      :abstract,                   :null => false
      t.integer     :order,                      :null => false, :default => 0

      t.timestamps
    end

    add_index :audio_lists, [:audio_list_category_id, :name, :order], unique: true
  end

end