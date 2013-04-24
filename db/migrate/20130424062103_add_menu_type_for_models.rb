class AddMenuTypeForModels < ActiveRecord::Migration

  def change

    add_column :scenics,               :menu_type, :string, :after => :is_free
    add_column :places,                :menu_type, :string, :after => :is_free
    add_column :recommends,            :menu_type, :string, :after => :is_free

  end

end