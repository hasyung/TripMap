class CreateNicknames < ActiveRecord::Migration
  def change
    create_table :nicknames do |t|
      t.references :map_serial_number, null: false
      t.string :nickname, null: false, limit: 30
      t.timestamps
    end

    add_index :nicknames, :nickname, unique: true
  end
end
