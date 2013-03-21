class AddVersionToMaps < ActiveRecord::Migration
  def change
  	add_column :maps,  :version, :string, limit: 30, :after => :slug
  end
end
