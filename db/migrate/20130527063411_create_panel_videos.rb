class CreatePanelVideos < ActiveRecord::Migration

  def change
    create_table :panel_videos do |t|
      t.references  :map,                    :null => false

      t.string  :name,                       :null => false
      #t.string  :slug,                      :null => false    # Polymorphic 'Keyword'
      #t.string  :slug_cover,                :null => false    # Polymorphic 'Image'
      t.string   :video,                     :null => false

      t.timestamps
    end
  end

end