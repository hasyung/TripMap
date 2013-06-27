class AddIsFreeAndMenuType < ActiveRecord::Migration

  def change
    add_column :first_knowns, :is_free, :boolean, :default => false, :after => :name
    add_column :first_knowns, :menu_type, :string,  :after => :name

    add_column :broadcasts, :is_free, :boolean, :default => false, :after => :name
    add_column :broadcasts, :menu_type, :string, :after => :name

    add_column :audio_list_categories, :is_free, :boolean, :default => false, :after => :name
    add_column :audio_list_categories, :menu_type, :string, :after => :name
  end

end