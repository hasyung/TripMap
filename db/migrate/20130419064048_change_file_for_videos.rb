class ChangeFileForVideos < ActiveRecord::Migration
  def change
  	change_column :videos, :file, :string, null: true
  end
end
