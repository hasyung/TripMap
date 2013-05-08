class AddTypeForDownloads < ActiveRecord::Migration

  def change

    add_column :downloads, :type, :integer, :default => 0, :after => :count

  end

end