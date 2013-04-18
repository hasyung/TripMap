class CreateVersions < ActiveRecord::Migration

  def change

    create_table :versions do |t|
      t.integer :platform,    :default => 0
      t.string  :value,       :null    => false
      t.string  :description
      t.string  :app

      t.timestamps
    end

    add_index :versions, [:platform, :value], :unique => true

  end

end