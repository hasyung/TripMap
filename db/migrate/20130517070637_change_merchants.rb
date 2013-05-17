class ChangeMerchants < ActiveRecord::Migration
  def up
    remove_index :merchants, [:county_id, :name, :address]
    add_column :merchants, :slug, :string, null: false, limit: 20, after: :name

    add_index :merchants, :name, unique: true
  end

  def down
    remove_index  :merchants, :name

    add_index :merchants, [:county_id, :name, :address], unique: true
    remove_column :merchants, :slug
  end
end
