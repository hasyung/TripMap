class AddUrlForVersions < ActiveRecord::Migration

  def change
    add_column :versions, :url, :string,  :after => :app
  end

end