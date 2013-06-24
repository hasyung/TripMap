class ChangeMinorities < ActiveRecord::Migration
  def change
    remove_column :minorities, :special_id
    add_column :minorities, :minorityable_id, :integer
    add_column :minorities, :minorityable_type, :string
  end
end
