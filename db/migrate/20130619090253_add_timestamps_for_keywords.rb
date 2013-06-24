class AddTimestampsForKeywords < ActiveRecord::Migration

  def change
    add_timestamps(:keywords)
  end

end