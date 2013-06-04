class AddVersionToKeywords < ActiveRecord::Migration

  def change
    add_column :keywords, :version, :string, :after => :slug
  end

end