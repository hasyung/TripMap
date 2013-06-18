class CreateFirstKnownLists < ActiveRecord::Migration

  def change
    create_table :first_known_lists do |t|
      t.references  :first_known,                :null => false

      #t.string     :first_known_list_icon,      :null => false    # Polymorphic 'Image'
      t.string      :title_cn,                   :null => false
      t.string      :title_en,                   :null => false
      t.string      :abstract
      t.string      :url
      t.integer     :order,                      :null => false, :default => 0

      t.timestamps
    end
  end

end