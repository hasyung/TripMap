class AddFileSizeToKeywords < ActiveRecord::Migration

  def change
    add_column :keywords, :file_size, :string, :after => :version
  end

end