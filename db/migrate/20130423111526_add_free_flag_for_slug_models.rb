class AddFreeFlagForSlugModels < ActiveRecord::Migration

  def change

    add_column :scenics,                :is_free, :boolean, :default => false, :after => :subtitle
    add_column :places,                 :is_free, :boolean, :default => false, :after => :subtitle
    add_column :recommends,             :is_free, :boolean, :default => false, :after => :recommend_records_count
    add_column :info_lists,             :is_free, :boolean, :default => false, :after => :order
    add_column :infos,                  :is_free, :boolean, :default => false, :after => :order

  end

end